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
# - "R"  = go right (smallest positive angle),
# - "L"  = go right (highest angle),
# - "B"  = go back (zero angle),
# - "S"  = go straight (closest angle to 0.5),
# - "2R" = go to second edge from the right, etc. ("3L", "5R", etc.)
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

################################################################
# Moves: to the right, to the left, going back, going straight #
################################################################
# Decide to which cell index to go according to the move to apply and
# knowing the current 'neighbors' data frame.
#
# Arguments:
# - neighbors: this data frame is defined from previous cell c_0 and current
# cell c. We expect at least 3 rows in this data frame. It must contain:
# * neighbors$index: index of neighbor cells of current cell c,
# * neighbors$angle: angle to edges, relative to direction (c_0 c)
# - howmany: for going left, move to the 'howmany' edge from the left,
#            for going right, move to the 'howmany' edge from the right.
# Note: arguments are explained in details in angle.R and get_neighbors.R
# Warning: With howmany > 1, user must ensure there is a sufficient number of
# edges in the polygon.
go_back = function(neighbors) {
  # The ant has crossed edge e passing from c_0 to c.
  # The relative angle for this edge e is 0.
  # We want to go back, so we need to cross again this edge e.
  # Thus, we select minimum relative angle which is 0 and corresponds 
  # to this edge. 
  idx = which.min(neighbors$angle)
  # The cell related to neighbors[idx,]$index is c_0. 
  return(neighbors[idx,]$index)
}

go_straight = function(neighbors) {
  # The relative angle stands in [0, 1[, and going straight corresponds
  # to an angle of 0.5. We select the cell c' such that relative angle
  # [relative to (c0 c)] is closest to 0.5.
  dist_to_half = abs(neighbors$angle - 0.5)
  idx = which.min(dist_to_half)
  
  # Checking if we can going straight unambiguously
  if(diff(sort(dist_to_half, partial=2)[1:2]) < 10e-9) {
    out = paste0("Going straight is ambiguous for this cell. ", 
                 "This occurs for regular polygons with odd edges.")
    stop(out)
  }
  
  return(neighbors[idx,]$index)
}

go_right = function(neighbors, howmany = 1) {
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
                 "go_right(", howmany, ").")
    stop(out)
  }
  
  # Output
  return(neighbors_sort[idx,]$index)
}

go_left = function(neighbors, howmany = 1) {
  # Similar to going right, but we select the howmany-th largest angle.
  neighbors_sort = neighbors[order(neighbors$angle),]
  idx = nrow(neighbors_sort) + 1 - howmany
  
  # Checking if we can apply 'howmany'
  if(idx < 1) {
    out = paste0("Number of polygons for this cell is not enough to apply ",
                 "go_left(", howmany, ").")
    stop(out)
  }
  
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
checkEquals(go_back(neighbors), 10)
# Going straight, closest angle is 0.4, i.e. to index 14
checkEquals(go_straight(neighbors), 14)
# Going right, smallest non zero angle is 0.1, i.e. to index 11
checkEquals(go_right(neighbors), 11)
# Second smallest non zero angle is 0.4, i.e. to index 14
checkEquals(go_right(neighbors, 2), 14)
checkEquals(go_right(neighbors, 3), 17)
checkEquals(go_right(neighbors, 4), 18)
# Going left, highest angle is 0.9, i.e. to index 19
checkEquals(go_left(neighbors), 19)
checkEquals(go_left(neighbors, 2), 18)
checkEquals(go_left(neighbors, 3), 17)
checkEquals(go_left(neighbors, 4), 14)

## An equilateral triangle
neighbors = data.frame(index = c(13, 16, 10), angle = c(1/3, 2/3, 0))
# Going back to angle 0, i.e. to index 10
checkEquals(go_back(neighbors), 10)
# Going straight is ambiguous for this polygon, throw errow
checkException(go_straight(neighbors), silent = TRUE)
checkEquals(go_right(neighbors), 13)
checkEquals(go_right(neighbors, 2), 16)
checkEquals(go_right(neighbors, 3), 10)
# Going right > n times is not defined for a n polygon, throw error 
checkException(go_right(neighbors, 4), silent = TRUE)
checkEquals(go_left(neighbors), 16)
checkEquals(go_left(neighbors, 2), 13)
checkEquals(go_left(neighbors, 3), 10)
# Going left > n times is not defined for a n polygon, throw error
checkException(go_left(neighbors, 4), silent = TRUE)
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
# - move: string corresponding to the move, such as "3L".
rule_apply = function(neighbors, move) {
  # Get the new index to go
  index_go = NA
  if(move == "R") {
    index_go = go_right(neighbors)
  } else if(move == "L") {
    index_go = go_left(neighbors)
  } else if(move == "B") {
    index_go = go_back(neighbors)
  } else if(move == "S") {
    index_go = go_straight(neighbors)
  } else {
    howmany = as.integer(substr(move, 1, nchar(move)-1))
    direction = substr(move, nchar(move), nchar(move))
    if(direction == "R") {
      index_go = go_right(neighbors, howmany)
    } else if(direction == "L") {
      index_go = go_left(neighbors, howmany)    
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
checkEquals(rule_apply(neighbors, "B"), go_back(neighbors))
checkEquals(rule_apply(neighbors, "S"), go_straight(neighbors))
checkEquals(rule_apply(neighbors, "R"), go_right(neighbors))
checkEquals(rule_apply(neighbors, "2R"), go_right(neighbors, 2))
checkEquals(rule_apply(neighbors, "3R"), go_right(neighbors, 3))
checkEquals(rule_apply(neighbors, "4R"), go_right(neighbors, 4))
checkEquals(rule_apply(neighbors, "L"), go_left(neighbors))
checkEquals(rule_apply(neighbors, "2L"), go_left(neighbors, 2))
checkEquals(rule_apply(neighbors, "3L"), go_left(neighbors, 3))
checkEquals(rule_apply(neighbors, "4L"), go_left(neighbors, 4))

## An equilateral triangle
neighbors = data.frame(index = c(13, 16, 10), angle = c(1/3, 2/3, 0))
checkException(rule_apply(neighbors, "S"), silent = TRUE)
checkException(rule_apply(neighbors, "4R"), silent = TRUE)
checkException(rule_apply(neighbors, "4L"), silent = TRUE)

## Checking 10L and 15L
neighbors = data.frame(index = 1:20, angle = seq(0, 1, length.out = 20))
checkEquals(rule_apply(neighbors, "10L"), go_left(neighbors, 10))
checkEquals(rule_apply(neighbors, "15R"), go_right(neighbors, 15))
rm(neighbors)