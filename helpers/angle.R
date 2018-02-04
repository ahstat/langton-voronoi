############################################################
# Helper function: Return center of cell from cell's index #
############################################################
# Given a tesselation, each cell is related with an index.
# Return the z of the current index
# Arguments:
# - index: an index following tess$summary order,
# - tess: an object of class deldir computed with create_tiling function.
z_index_func = function(index, tess) {
  z_index = tess$summary[index,]
  z_index = z_index$x + 1i * z_index$y
  return(z_index)
}

##
# Unit test
##
N = 3
z = simulation_square(N)
m = 2
space_out = 3
tess = create_tiling(z, m, plot_points = FALSE, space_out)
index = 37
checkEqualsNumeric(Re(z_index_func(index, tess)), tess$summary$x[index])
checkEqualsNumeric(Im(z_index_func(index, tess)), tess$summary$y[index])
rm(N, z, m, space_out, tess, index)

################################################################
# Compute angle of all edges of a cell relative to a direction #
################################################################
# In the tesselation, we consider two neighbor cells c_0 and c.
# c_0 is the previous cell and c is the current cell
# The current cell c is a polygon with edges e_1, ..., e_m
# Ant going from c_0 to c cross e_i one of the edges.
# From the ant point of view, e_i corresponds to angle 0.
# The ant can look from right to left and observe increasing angles
# for each edge (in detail: z_edge the middle of each edge).
#
# The function computes angle for each neighbor edges and add it to the
# neighbor edges data frame.
# Angles are in [0, 1[ from right to left, and with 0 corresponding to the
# edge going back to previous cell.
#
# Arguments:
# - neighbors: neighbor edges of current cell c computed from neighbors_func
# of get_neighbors.R
# - index: index of c the current cell
# - index_previous: index of c_0 the previous cell
# - tess: an object of class deldir (cell are indexed through tess$summary)
angle = function(neighbors, index, index_previous, tess) {
  # Position of the center of current cell
  z_center = z_index_func(index, tess)
  
  # Position of the middle of the edge crossed by the ant from c_0 to c
  z_edge_previous = neighbors$z_edge[which(neighbors$index == index_previous)]
  
  # Angles in [-pi, pi] between 
  # (z_edge_previous, z_center) and (z_edge, z_center)
  # for each z_edge related to an edge of cell c.
  # So 'ang' is a vector with one value for each edge
  ang = Arg(neighbors$z_edge - z_center) - Arg(z_edge_previous - z_center)
  
  # Angles in [-1, 1]
  ang = ang / (2*pi)
  
  # Sometimes, angle is -10^-17 and then we get angle %% 1 = 1.
  # We consider those angles as 0 (going back)
  ang[abs(ang) < 1e-15] = 0
  
  # Angles in [0, 1[
  ang = ang %% 1
  
  return(ang)
}

##
# Unit tests
##
## Example with squares
z = 0 + 0 * 1i
m = 1
space_out = 3
tess = create_tiling(z, m, plot_points = FALSE, space_out)
index = index_init_func(tess)
index_previous = index_previous_func(tess, index, "bottom_to_up")
neighbors = neighbors_func(index, tess)
checkTrue(all(abs(neighbors$neighbors$z_edge) == 0.5))
angles = angle(neighbors$neighbors, index, index_previous, tess)
angle_go_back = angles[which(neighbors$neighbors$index == index_previous)]
checkEqualsNumeric(angle_go_back, 0)
checkTrue(all(sort(angles) == c(0, 0.25, 0.5, 0.75)))
rm(z, m, space_out, tess, index, index_previous, neighbors, 
   angles, angle_go_back)