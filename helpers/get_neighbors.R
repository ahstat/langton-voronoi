#########################################################
# Helper function: Restrict dirsgs to edges of interest #
#########################################################
# From a deldir object tess, we can access to edges with tess$dirsgs.
# There are more edges than cells.
# For an edge e, tess$dirsgs[e,c(ind1, ind2)] is the two indexes related
# to the two cells sharing edge e.
#
# The following function restricts tess$dirsgs to rows/edges related with a
# certain index 'index'.
# Arguments:
# - dirsgs: a data frame of edges obtained from tess$dirsgs,
# - index: index of the cell of interest.
dirsgs_restric_index = function(dirsgs, index) {
  return(dirsgs[dirsgs$ind1 == index | dirsgs$ind2 == index,])
}

##
# Example
##
N = 3
z = simulation_square(N)
m = 2
space_out = 3
tess = create_tiling(z, m, plot_points = FALSE, space_out)
dirsgs = tess$dirsgs
index = 37
df_edge_of_interest = dirsgs_restric_index(dirsgs, index) 
rm(N, z, m, space_out, tess, dirsgs, index, df_edge_of_interest)

##############################################################
# Helper function: Euclidian distance of each edge of dirsgs #
##############################################################
# Argument:
# - dirsgs: a data frame of edges obtained from tess$dirsgs
distance_of_edges = function(dirsgs) {
  return((dirsgs$x1 - dirsgs$x2)^2 + (dirsgs$y1 - dirsgs$y2)^2)
}

##
# Example
##
N = 3
z = simulation_square(N)
m = 2
space_out = 3
tess = create_tiling(z, m, plot_points = FALSE, space_out)
dirsgs = tess$dirsgs
index = 37
dirsgs = dirsgs_restric_index(dirsgs, index) 
dist_out = distance_of_edges(dirsgs) 
rm(N, z, m, space_out, tess, dirsgs, index, dist_out)

###################################################################
# Helper function: Check if dirsgs contains cells at the boundary #
###################################################################
# Whether dirsgs contain some cells at the boundary
# (in practice this function is applied on a subset of tell$dirsgs).
is_boundary = function(dirsgs) {
  # bp1 and bp2 are logical values indicating whether cell is in
  # border position, according to dirsgs documentation
  return(!all(!c(dirsgs$bp1, dirsgs$bp2)))
}

##
# Unit tests
##
N = 3
z = simulation_square(N)
m = 2
space_out = 3
tess = create_tiling(z, m, plot_points = FALSE, space_out)
dirsgs = tess$dirsgs
# With all the cells, there are some edges at the boundary
checkEquals(is_boundary(dirsgs), TRUE)
index = 37
dirsgs = dirsgs_restric_index(dirsgs, index)
# index 37 is in the center of the tesselation, so the neighbors cells
# are not the border.
checkEquals(is_boundary(dirsgs), FALSE)
rm(N, z, m, space_out, tess, dirsgs, index)

################################################
# Main function to compute neighbors of a cell #
################################################
# Given a tesselation and a current cell, compute edges of this cell and
# for each edge, give:
# * z_edge: the middle position of the edge,
# * index: the cell obtained after crossing the edge from current cell
# Each edge is a row of an outputed data frame 
# The function also outputs whether the current cell is located at the
# border.
#
# Arguments:
# - index: index of the current cell of interest.
# - tess: an object of class deldir
neighbors_func = function(index, tess) {
  # Only take dirsgs
  dirsgs = tess$dirsgs
  
  # Remove unused columns
  dirsgs = dirsgs[,-which(colnames(dirsgs) %in% c("thirdv1", "thirdv2"))]
  dirsgs_all = dirsgs
  
  # Only take rows related to index
  dirsgs = dirsgs_restric_index(dirsgs, index)
  
  # Some cells c1 and c2 can be connected with an edge e which is
  # simply a vertex: e = (v, v). We remove such rows from dirsgs.
  dirsgs = dirsgs[which(distance_of_edges(dirsgs) > 0), ]
  
  # ind1 and ind2 merged by taking for each row the cell which is not 'index'
  # After this operation, ind2 column is deleted, we only keep ind1.
  idx_change = which(dirsgs$ind1 == index)
  dirsgs$ind1[idx_change] = dirsgs$ind2[idx_change]
  dirsgs = dirsgs[,-which(colnames(dirsgs) == "ind2")]
  
  # Get all neighbors cells (connected with an edge to 'index'),
  # and get position of the mean of each edge
  z_edge = (dirsgs$x1 + dirsgs$x2)/2 + 1i * (dirsgs$y1 + dirsgs$y2)/2
  index_neighbors = dirsgs$ind1
  neighbors = data.frame(z_edge = z_edge, index = index_neighbors)
  
  # Check if the index is a cell such that at least one neighbor
  # is at the boundary
  # (it is not sufficient to check if cell is at the boundary)
  is_bound = FALSE
  for(idx in index_neighbors) {
    dirsgs_n = dirsgs_restric_index(dirsgs_all, idx)
    dirsgs_n = dirsgs_n[which(distance_of_edges(dirsgs_n) > 0), ]
    is_bound = is_bound | is_boundary(dirsgs_n)
    # print(is_bound)
  }
  
  return(list(neighbors = neighbors, is_bound = is_bound))
}

##
# Example
##
N = 3
z = simulation_square(N)
m = 2
space_out = 3
tess = create_tiling(z, m, plot_points = FALSE, space_out)

## Example 1
index = 37
df = neighbors_func(index, tess)
# $neighbors
# z_edge index
# 1 -0.8193230-0.0039675i    34
# 2 -0.8133135+0.0991010i    35
# 3 -0.7704980-0.2087525i    36
# 4 -0.3133135+0.0991010i    38
# 5 -0.2704980-0.2087525i    39
# 6  0.1806770-0.0039675i    40
# 
# $is_bound
# [1] FALSE

## Example 2
index_border = which.min(tess$dirsgs$bp1 == TRUE)
df = neighbors_func(index_border, tess)
# $neighbors
# z_edge index
# 1 -2.413826+1.751724i     3
# 2 -4.163826+1.568980i    17
# 3 -3.569323+2.156810i     2
# 4 -1.819323+1.996033i     4
# 
# $is_bound
# [1] TRUE
rm(N, z, m, space_out, tess, index, index_border, df)