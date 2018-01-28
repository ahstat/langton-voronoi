# This file to get the neighbors from dirsgs component of deldir()

##
# Main function
##
# Get the index of the neighbors for a cell, and get the related center
#  of the edges.
# Also, output if this cell is at the bound (i.e. some neighbors are missing).
neighbors_func = function(index, tess) {
  z_index_func(index, tess)
  
  # Only take dirsgs
  dirsgs = tess$dirsgs
  # Only take related to index
  dirsgs_index = dirsgs_index_func(dirsgs, index)
  # Only take related to index with an edge
  dis = dirsgs_remove_vertex(dirsgs_index, index)
  
  # Check if the index is a cell at the boundary
  is_bound = is_boundary(dirsgs_index)
  
  # Get all neighbors cells (connected with an edge to index),
  # and get the position of the mean of each edge
  neighbors = data.frame(z_edge = (dis$x1 + dis$x2)/2 + 1i * (dis$y1 + dis$y2)/2,
                         index = dis$ind1)
  
  return(list(neighbors = neighbors, is_bound = is_bound))
}

##
# Helper functions
##

# Return the z of the current index
z_index_func = function(index, tess) {
  z_index = tess$summary[index,]
  z_index = z_index$x + 1i * z_index$y
  return(z_index)
}

# From dirsgs, take only element related with index
dirsgs_index_func = function(dirsgs, index) {
  return(dirsgs[dirsgs$ind1 == index | dirsgs$ind2 == index,])
}

# Check if the current index is the boundary of the map
is_boundary = function(dirsgs_index) {
  return(!all(!c(dirsgs_index$bp1, 
                 dirsgs_index$bp2)))
}

# Euclidian distance of dirsgs elements
distance = function(dis) {
  return((dis$x1 - dis$x2)^2 + (dis$y1 - dis$y2)^2)
}

# Remove neighbors of index only connected by a vertex (and not an edge)
dirsgs_remove_vertex = function(dirsgs_index, index) {
  # dis = dirsgs_index_small
  dis = dirsgs_index[,-which(colnames(dirsgs_index) %in% c("bp1", 
                                                           "bp2", 
                                                           "thirdv1", 
                                                           "thirdv2"))]
  dis = dis[which(distance(dis)>0),]
  idx_change = which(dis$ind1 == index)
  dis$ind1[idx_change] = dis$ind2[idx_change]
  dis = dis[,-which(colnames(dis) == "ind2")]
  return(dis)
}