##
# Get initial values
##
# Take initial index as the closest point to z
# n between 1 and N (where N is the nb of points in the square [-0.5,0.5]^2).
index_init_func = function(tess, 
                           n = 1,
                           closest = FALSE, z_init = 0 + 1i * 0) {
  z_periodic = tess$summary$x + 1i * tess$summary$y
  idx_center = which(abs(Re(z_periodic))<0.5 & abs(Im(z_periodic))<0.5)
  z_center_square = z_periodic[idx_center]
  if(closest == TRUE) {
    # Take the point which is closest to z_init
    index_init = idx_center[which.min(abs(z_center_square - z_init))]
  } else {
    index_init = idx_center[n]
  }
  return(index_init)
}

# Parameter: From which cell we initially came
# From the mean value of edges of the cell index_init,
#   take the lowest Im (which should be the "lowest" edge)
index_previous_func = function(tess, index, 
                               e = 1, from = NULL) {
  neighbors_list = neighbors_func(index, tess)
  neighbors = neighbors_list$neighbors
  
  if(!is.null(from)) {
    if(from == "bottom_to_up") {
      out_index = which.min(Im(neighbors$z_edge))
    } else if(from == "up_to_bottom") {
      out_index = which.max(Im(neighbors$z_edge))
    } else if(from == "left_to_right") {
      out_index = which.min(Re(neighbors$z_edge))
    } else if(from == "right_to_left") {
      out_index = which.max(Re(neighbors$z_edge))
    } else {
      print("Random initial coming edge")
      out_index = sample(1:length(neighbors$z_edge), 1)
    }
  } else {
    out_index = e
  }
  
  output = neighbors$index[out_index]
  return(output)
}

# Initialize previous passing
# The content may depend of what we want;
#   by default R to the first step and alternance L, R after
# For one ant, we can only see the indexes and check the odd/even, and
#   may be quicker. But for the whole generalization, use this.
initialize_previous_passing = function(tess) {
  nb_cells = length(tess$ind.orig)
  previous_passing_list = sapply(1:nb_cells,function(x) NULL)
  return(previous_passing_list)
}