# rule_RL = function(previous_passing) {
#   if(length(previous_passing) == 0) {
#     # go right
#     passing_new = "R"
#   } else {
#     previous_passing_last = previous_passing[length(previous_passing)]
#     if(previous_passing_last == "L") {
#       passing_new = "R"
#     } else { # can only be "R"
#       passing_new = "L"
#     }
#   }
#   return(passing_new)
# }

# Get the new index according to the rule in the current cell
rule_func = function(previous_passing, rule = "R L") {
  rule_vect = strsplit(rule, " ")[[1]]
  len_previous = (length(previous_passing) %% length(rule_vect)) + 1
  passing_new = rule_vect[len_previous]
  return(passing_new)
}

##
# Go where
##
# Could be dependent of the number of edges of the polygon,
# Go 2, 3, 4 left to check if we can do it modulo the nb edges of the polygon.
go_right = function(neighbors, howmany = 1) {
  # Replace by NA the lowest element (no angle)
  neighbors_new = neighbors
  neighbors_new$angle[which.min(neighbors_new$angle)] = NA
  
  neighbors_sort = neighbors_new[order(neighbors_new$angle),]
  idx = howmany
  # idx = which.min(neighbors_new$angle)
  return(neighbors_sort[idx,]$index)
}

go_left = function(neighbors, howmany = 1) {
  neighbors_sort = neighbors[order(neighbors$angle),]
  idx = nrow(neighbors_sort) + 1 - howmany
  return(neighbors_sort[idx,]$index)
}

go_back = function(neighbors) {
  idx = which.min(neighbors$angle)
  return(neighbors[idx,]$index)
}

go_straight = function(neighbors) {
  idx = which.min(abs(neighbors$angle - 0.5))
  return(neighbors[idx,]$index)
}

# previous_passing can have another shape, here it is c("R", "L", ...)
# but we can also think with angle (take the next angle etc.)
rule_apply = function(neighbors, new_passing) {
  # get the new index to go
  index_go = NA
  if(new_passing == "R") {
    index_go = go_right(neighbors)
  } else if(new_passing == "L") {
    index_go = go_left(neighbors)    
  } else if(new_passing == "B") {
    index_go = go_back(neighbors)    
  } else if(new_passing == "S") {
    index_go = go_straight(neighbors)    
  } else {
    howmany = as.integer(substr(new_passing, 1, nchar(new_passing)-1))
    direction = substr(new_passing, nchar(new_passing), nchar(new_passing))
    if(direction == "R") {
      index_go = go_right(neighbors, howmany)
    } else if(direction == "L") {
      index_go = go_left(neighbors, howmany)    
    } else {
      stop("Error in direction")
    }
  }
  return(index_go)
}