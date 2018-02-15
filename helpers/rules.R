###############################################
# Which move is applied according to the rule #
###############################################
# Compute the move to apply according to the rule and the
# previous moves in the current cell.
#
# Arguments:
# - previous_moves: a vector containing previous moves applied in this cell
# - rule: a string containing rule of moving, each move separated by a space
#
# Possible moves (described in following functions):
# - "B"  = go backward (edge related to zero angle),
# - "S"  = go starboard (edge related to lowest positive angle),
# - "R"  = go right (median edge minus 1 ; always well-defined)
# - "F"  = go forward (median edge ; undefined if odd number of polygons),
# - "L"  = go left (median edge plus 1 ; always well-defined),
# - "P"  = go port (edge related to the highest angle).
# - "2S" = go to second edge from the right (works with "S" and "P")
#
# Example with an octogon (original direction marked with an arrow):
#           F
#        _______
#   L  .'       '. R
#    .'           '.
#    |             |
# 2P |             | 2S
#    |             |
#    '.     ^     .'
#   P  '.___|___.' S
#           |
#           B
#
# Example with a pentagon (original direction marked with an arrow):
#
#       .'.
#   L .'   '. R
#   .'       '.
#   \    ^    /
#  P \   |   / S
#     \__|__/
#        |
#        B
# Figure inspired from brtmr.de/2015/10/05/hexadecimal-langtons-ant-2.html

rule_func = function(previous_moves, rule = "R L") {
  rule_vect = strsplit(rule, " ")[[1]]
  len_previous = (length(previous_moves) %% length(rule_vect)) + 1
  move = rule_vect[len_previous]
  return(move)
}

##
# Unit tests
##
# First time in this cell, the rule say to move to the right
checkEquals(rule_func(NULL, "R L"), "R")
# Second time in this cell, the rule say to move to the left
checkEquals(rule_func(c("R"), "R L"), "L")
# Third time in this cell, the rule say to move to the right
checkEquals(rule_func(c("R", "L"), "R L"), "R")
# Fourth time in this cell, the rule say to move to the left
checkEquals(rule_func(c("R", "L", "R"), "R L"), "L")
# With the rule "L", we need to move to the left
checkEquals(rule_func(c("L", "L", "L"), "L"), "L")
# With the rule "3R 5L B", fourth time in this cell, we move to "3R"
checkEquals(rule_func(c("3R", "5L", "B"), "3R 5L B"), "3R")
# Note: We cannot change rules during process. For example:
# rule_func(c("L"), "R L") must not arise and will give unexpected
# results. It is difficult to remove ambiguity in those cases, for
# example: rule_func(c("L"), "R L L") should be "L" or "R"?

#########################################################################
# Moves: to the right, to the left, going backward, going forward, etc. #
#########################################################################
# Decide to which cell index to go according to the move to apply and
# knowing the current 'neighbors' data frame.
#
# Arguments:
# - neighbors: this data frame is defined from previous cell c_0 and current
# cell c. We expect at least 3 rows in this data frame. It must contain:
# * neighbors$index: index of neighbor cells of current cell c,
# * neighbors$angle: angle to edges, relative to direction (c_0 c)
# - howmany: for going port, move to the 'howmany' edge from the left,
#            for going starboard, move to the 'howmany' edge from the right.
# Note: arguments are explained in details in angle.R and get_neighbors.R
# Warning: With howmany > 1, user must ensure there is a sufficient number of
# edges in the polygon.
go_backward = function(neighbors) {
  # The ant has crossed edge e passing from c_0 to c.
  # The relative angle for this edge e is 0.
  # We want to go back, so we need to cross again this edge e.
  # Thus, we select minimum relative angle which is 0 and corresponds 
  # to this edge. 
  idx = which.min(neighbors$angle)
  # The cell related to neighbors[idx,]$index is c_0. 
  return(neighbors[idx,]$index)
}

go_starboard = function(neighbors, howmany = 1) {
  # The relative angle stands in [0, 1[ and 0 corresponds to going back.
  # We delete the lowest angle, and sort the remaining angles.
  # The howmany-th index corresponds to the howmany-th move to the right.

  # Replace by NA the lowest element (no angle)
  neighbors_new = neighbors
  neighbors_new$angle[which.min(neighbors_new$angle)] = NA
  
  # Sorting elements by increasing angles
  neighbors_sort = neighbors_new[order(neighbors_new$angle),]
  
  # Selecting the howmany-th index
  idx = howmany
  
  # Checking if we can apply 'howmany'
  if(idx > nrow(neighbors_sort)) {
    out = paste0("Number of polygons for this cell is not enough to apply ",
                 "go_starboard(", howmany, ").")
    stop(out)
  }
  
  # Output
  return(neighbors_sort[idx,]$index)
}

go_port = function(neighbors, howmany = 1) {
  # Similar to going right, but we select the howmany-th largest angle.
  neighbors_sort = neighbors[order(neighbors$angle),]
  idx = nrow(neighbors_sort) + 1 - howmany
  
  # Checking if we can apply 'howmany'
  if(idx < 1) {
    out = paste0("Number of polygons for this cell is not enough to apply ",
                 "go_port(", howmany, ").")
    stop(out)
  }
  
  # Output
  return(neighbors_sort[idx,]$index)
}

go_right = function(neighbors) {
  E = nrow(neighbors)
  neighbors_sort = neighbors[order(neighbors$angle),]
  
  idx = ceiling(E/2)
  
  # idx = 1 corresponds to angle 0: going back
  # E = 3 (triangle) --> idx = 2 is to the right,
  # E = 4 (square) --> idx = 2 is to the right,
  # E = 5 (pentagon) --> idx = 3 is to the straight-right
  # etc.

  # Output
  return(neighbors_sort[idx,]$index)
}

go_left = function(neighbors) {
  E = nrow(neighbors)
  neighbors_sort = neighbors[order(neighbors$angle),]
  
  idx = ceiling((E+1)/2) + 1
  
  # idx = 1 corresponds to angle 0: going back
  # E = 3 (triangle) --> idx = 3 is to the left,
  # E = 4 (square) --> idx = 4 is to the left,
  # E = 5 (pentagon) --> idx = 4 is to the straight-left
  # etc.
  
  # Output
  return(neighbors_sort[idx,]$index)
}

go_forward = function(neighbors) {
  E = nrow(neighbors)
  if(E %% 2 == 1) {
    stop("Cannot go straight, current polygon has odd number of edges.")
  }
  neighbors_sort = neighbors[order(neighbors$angle),]
  
  idx = ceiling(E/2) + 1
  
  # idx = 1 corresponds to angle 0: going back
  # E = 4 (square) --> idx = 3 is to the right,
  # E = 6 (hexagon) --> idx = 4 is to the straight-right
  # etc.
  
  # Output
  return(neighbors_sort[idx,]$index)
}

##
# Unit tests
##
## An ordinary polygon
neighbors = data.frame(index = c(17, 14, 19, 11, 18, 10),
                       angle = c(0.7, 0.4, 0.9, 0.1, 0.8, 0))
# Going back to angle 0, i.e. to index 10
checkEquals(go_backward(neighbors), 10)
# Going forward, median angle corrsponds to index 17
checkEquals(go_forward(neighbors), 17)
# Going starboard, smallest non zero angle is 0.1, i.e. to index 11
checkEquals(go_starboard(neighbors), 11)
# Second smallest non zero angle is 0.4, i.e. to index 14
checkEquals(go_starboard(neighbors, 2), 14)
checkEquals(go_starboard(neighbors, 3), 17)
checkEquals(go_starboard(neighbors, 4), 18)
# Going port, highest angle is 0.9, i.e. to index 19
checkEquals(go_port(neighbors), 19)
checkEquals(go_port(neighbors, 2), 18)
checkEquals(go_port(neighbors, 3), 17)
checkEquals(go_port(neighbors, 4), 14)
# Ordered (by angles) idx are: 10 11 14 17 18 19
# 10 corresponds to going backward, then 11 (starboard), 14 (right),
# then 17 is going forward,
# then 18 (left), 19 (port).
checkEquals(go_right(neighbors), 14)
checkEquals(go_left(neighbors), 18)

## An equilateral triangle
neighbors = data.frame(index = c(13, 16, 10), angle = c(1/3, 2/3, 0))
# Going back to angle 0, i.e. to index 10
checkEquals(go_backward(neighbors), 10)
# Going forward is not possible for triangles, throws error
checkException(go_forward(neighbors), silent = TRUE)
checkEquals(go_starboard(neighbors), 13)
checkEquals(go_starboard(neighbors, 2), 16)
checkEquals(go_starboard(neighbors, 3), 10)
# Going right > n times is not defined for a n polygon, throw error 
checkException(go_starboard(neighbors, 4), silent = TRUE)
checkEquals(go_port(neighbors), 16)
checkEquals(go_port(neighbors, 2), 13)
checkEquals(go_port(neighbors, 3), 10)
# Going left > n times is not defined for a n polygon, throw error
checkException(go_port(neighbors, 4), silent = TRUE)
# Going left and right is same as port and starboard here
checkEquals(go_right(neighbors), 13)
checkEquals(go_left(neighbors), 16)
rm(neighbors)

##############################################################
# Applying the move given the string outputed from rule_func #
##############################################################
# rule_func outputs a string, for example "R", "L" or "3L".
# The following function decide to which cell index to go according
# to the move to apply as a string and knowing the current 'neighbors'
# data frame.
#
# Arguments:
# - neighbors: this data frame is defined from previous cell c_0 and current
# cell c. We expect at least 3 rows in this data frame. It must contain:
# * neighbors$index: index of neighbor cells of current cell c,
# * neighbors$angle: angle to edges, relative to direction (c_0 c)
# - move: string corresponding to the move, such as "3P".
rule_apply = function(neighbors, move) {
  # Get the new index to go
  index_go = NA
  if(move == "S") {
    index_go = go_starboard(neighbors)
  } else if(move == "P") {
    index_go = go_port(neighbors)
  } else if(move == "B") {
    index_go = go_backward(neighbors)
  } else if(move == "R") {
    index_go = go_right(neighbors)
  } else if(move == "L") {
    index_go = go_left(neighbors)
  } else if(move == "F") {
    index_go = go_forward(neighbors)
  } else {
    howmany = as.integer(substr(move, 1, nchar(move)-1))
    direction = substr(move, nchar(move), nchar(move))
    if(direction == "S") {
      index_go = go_starboard(neighbors, howmany)
    } else if(direction == "P") {
      index_go = go_port(neighbors, howmany)    
    } else {
      stop("move string is unknown.")
    }
  }
  return(index_go)
}

##
# Unit tests
##
## An ordinary polygon
neighbors = data.frame(index = c(17, 14, 19, 11, 18, 10),
                       angle = c(0.7, 0.4, 0.9, 0.1, 0.8, 0))
checkEquals(rule_apply(neighbors, "B"), go_backward(neighbors))
checkEquals(rule_apply(neighbors, "F"), go_forward(neighbors))
checkEquals(rule_apply(neighbors, "R"), go_right(neighbors))
checkEquals(rule_apply(neighbors, "L"), go_left(neighbors))
checkEquals(rule_apply(neighbors, "S"), go_starboard(neighbors))
checkEquals(rule_apply(neighbors, "2S"), go_starboard(neighbors, 2))
checkEquals(rule_apply(neighbors, "3S"), go_starboard(neighbors, 3))
checkEquals(rule_apply(neighbors, "4S"), go_starboard(neighbors, 4))
checkEquals(rule_apply(neighbors, "P"), go_port(neighbors))
checkEquals(rule_apply(neighbors, "2P"), go_port(neighbors, 2))
checkEquals(rule_apply(neighbors, "3P"), go_port(neighbors, 3))
checkEquals(rule_apply(neighbors, "4P"), go_port(neighbors, 4))

## An equilateral triangle
neighbors = data.frame(index = c(13, 16, 10), angle = c(1/3, 2/3, 0))
checkException(rule_apply(neighbors, "F"), silent = TRUE)
checkException(rule_apply(neighbors, "4S"), silent = TRUE)
checkException(rule_apply(neighbors, "4P"), silent = TRUE)

## Checking 15R and 10L
neighbors = data.frame(index = 1:20, angle = seq(0, 1, length.out = 20))
checkEquals(rule_apply(neighbors, "15S"), go_starboard(neighbors, 15))
checkEquals(rule_apply(neighbors, "10P"), go_port(neighbors, 10))
rm(neighbors)