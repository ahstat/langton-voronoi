################
# Initial cell #
################
# Given a tesselation, each cell is related with an index.
# The following function gives the initial index, i.e. the cell where
# the ant stands at the initial step t = 1.
#
# Arguments:
# - tess: an object of class deldir computed with create_tiling function,
# - n: if n = NULL, we take the cell which has the closest "center" to (0,0)
#      if n is a positive integer, the N cells in the initial square are 
# indexed from 1 to N and we select the n-th cell from this index.
index_init_func = function(tess, n = NULL) {
  # Each row of tess$summary is related to a cell of the Voronoi tesselation
  # We extract "centers" of all cells:
  z_periodic = tess$summary$x + 1i * tess$summary$y
  # We retrieve index of cells standing in ]-0.5, 0.5[^2
  idx_center = which(abs(Re(z_periodic))<0.5 & abs(Im(z_periodic))<0.5)
  # The related "centers" are:
  z_center_square = z_periodic[idx_center]
  
  if(is.null(n)) {
    # Take the point which is closest to 0 = (0, 0)
    index_init = idx_center[which.min(abs(z_center_square))]
  } else {
    # We take the n-th element according to tess$summary order
    if(n > length(idx_center)) {
      stop("n cannot be greater than N number of cells in the initial square")
    }
    index_init = idx_center[n]
  }
  return(index_init)
}

##
# Unit tests
##
## Random example
N = 3
z = simulation_square(N)
m = 2
space_out = 3
tess = create_tiling(z, m, plot_points = FALSE, space_out)
checkTrue(index_init_func(tess, n = NULL) %in% c(37, 38, 39))
checkEquals(index_init_func(tess, n = 1), 37)
checkEquals(index_init_func(tess, n = 2), 38)
checkEquals(index_init_func(tess, n = 3), 39)
checkException(index_init_func(tess, n = 4), silent = TRUE)
# Checking that 37, 38, 39 are three elements in the unit square
checkTrue(all(abs(tess$summary[c(37, 38, 39), "x"]) < 0.5))
checkTrue(all(abs(tess$summary[c(37, 38, 39), "y"]) < 0.5))
rm(N, z, m, space_out, tess)

## Example with squares
z = 0 + 0 * 1i
m = 1
space_out = 3
tess = create_tiling(z, m, plot_points = FALSE, space_out)
index = index_init_func(tess)
checkTrue(all(tess$summary[index,c("x", "y")] == c(0, 0)))
rm(z, m, space_out, tess, index)

#########################
# Initial previous cell #
#########################
# Give index cell where the ant stands before initial step, i.e. at t = 0. 
# We need this information to define left and right from the ant point of view.
#
# Arguments:
# - tess: an object of class deldir computed with create_tiling function,
# - index: cell where is the ant at t = 1 (initial step)
# - from: the rule to define the ant at t = 0 (previous position)
# It can be:
#   * "bottom_to_up"
#   * "up_to_bottom"
#   * "left_to_right"
#   * "right_to_left"
#   * "random"
#   * an integer between 1 and E (E = the number of edges of current cell)
index_previous_func = function(tess, index, from = "bottom_to_up") {
  neighbors_list = neighbors_func(index, tess)
  neighbors = neighbors_list$neighbors
  z_edge = neighbors$z_edge
  E = length(z_edge)
  
  # Cell the ant initially came is defined according to z_edge 
  # center of edges of the current cell.
  # For example, edge with the lowest Im should be the edge at the bottom
  # of the current cell (approximatively)
  if(from == "bottom_to_up") {
    out_index = which.min(Im(z_edge))
  } else if(from == "up_to_bottom") {
    out_index = which.max(Im(z_edge))
  } else if(from == "left_to_right") {
    out_index = which.min(Re(z_edge))
  } else if(from == "right_to_left") {
    out_index = which.max(Re(z_edge))
  } else if(from == "random") {
    out_index = sample(1:E, 1)
  } else if(is.numeric(from)) {
    if(!(from %in% 1:E)) {
      stop("If numeric, 'from' must be between 1 and nb of edges of the cell")
    }
    out_index = from
  } else {
    stop("Method to define initial coming edge is unknown.")
  }

  output = neighbors$index[out_index]
  return(output)
}

##
# Unit tests
##
## Classic example with squares (N = 1)
N = 1
z = simulation_square(N)
m = 2
space_out = 3
tess = create_tiling(z, m, plot_points = FALSE, space_out)
index = index_init_func(tess, n = NULL)
neighbors = neighbors_func(index, tess)$neighbors
# The neighbors cells are 8, 12, 14, 18
checkEquals(neighbors$index, c(8, 12, 14, 18))
# With from = 1 to 4, we obtain cells 8, 12, 14, 18
checkEquals(index_previous_func(tess, index, from = 1), 8)
checkEquals(index_previous_func(tess, index, from = 2), 12)
checkEquals(index_previous_func(tess, index, from = 3), 14)
checkEquals(index_previous_func(tess, index, from = 4), 18)
# With directions
idx1 = neighbors$index[which.min(Im(neighbors$z_edge))] # bottom
idx2 = neighbors$index[which.max(Im(neighbors$z_edge))] # up
idx3 = neighbors$index[which.min(Re(neighbors$z_edge))] # left
idx4 = neighbors$index[which.max(Re(neighbors$z_edge))] # right
checkEquals(index_previous_func(tess, index, "bottom_to_up"), idx1)
checkEquals(index_previous_func(tess, index, "up_to_bottom"), idx2)
checkEquals(index_previous_func(tess, index, "left_to_right"), idx3)
checkEquals(index_previous_func(tess, index, "right_to_left"), idx4)
rm(N, z, m, space_out, tess, index, neighbors, idx1, idx2, idx3, idx4)

## Another example with fixed squares
z = 0 + 0 * 1i
m = 1
space_out = 3
tess = create_tiling(z, m, plot_points = FALSE, space_out)
index = index_init_func(tess)
index_previous = index_previous_func(tess, index, "bottom_to_up")
checkTrue(all(tess$summary[index_previous,c("x", "y")] == c(0, -1)))
index_previous = index_previous_func(tess, index, "up_to_bottom")
checkTrue(all(tess$summary[index_previous,c("x", "y")] == c(0, 1)))
index_previous = index_previous_func(tess, index, "left_to_right")
checkTrue(all(tess$summary[index_previous,c("x", "y")] == c(-1, 0)))
index_previous = index_previous_func(tess, index, "right_to_left")
checkTrue(all(tess$summary[index_previous,c("x", "y")] == c(1, 0)))
rm(z, m, space_out, tess, index, index_previous)

############################
# Initial previous passing #
############################
# We initialize how the ant has moved on each cell before t = 1.
# The simplest initialization is to say that the ant has not crossed any
# cell yet, so each cell has NULL as previous moves.
# Argument:
# - tess: an object of class deldir
initialize_previous_moves = function(tess) {
  nb_cells = length(tess$ind.orig)
  previous_moves_list = sapply(1:nb_cells, function(x) NULL)
  return(previous_moves_list)
}
# Note: we could imagine to let some cells to "R" at the beginning, 
# according to the rule (see rules.R for information about rule for the ant
# moves).
##
# Unit test
##
N = 3
z = simulation_square(N)
m = 2
space_out = 3
tess = create_tiling(z, m, plot_points = FALSE, space_out)
checkTrue(all(unlist(lapply(initialize_previous_moves(tess), is.null))))
checkEquals(length(initialize_previous_moves(tess)), 75)
rm(N, z, m, space_out, tess)