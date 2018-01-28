perform_walk = function(index_previous_init, index_init,
                        tess, vp,
                        output_shape, max_iterations, rule, modulo, colmax,
                        when_plot, size_png) {
  ##
  # Global variables for the walk
  ##
  # All the indexes from the begining
  indexes = c(index_previous_init, index_init)
  
  # For each cell, which direction we selected before
  previous_passing_list = initialize_previous_passing(tess)
  
  # Stop or not
  stop = FALSE
  
  ##
  # Create the folders
  ##
  out_folder = output_file(output_shape, only_folder = TRUE)
  folder_create_func(out_folder)
  
  ##
  # Perform computations
  ##
  for(iteration in 1:max_iterations) {
    if(!stop) {
      print(iteration)
      ##
      # Current position, previous position, and previous passing in the
      #   current position.
      ##
      index = indexes[length(indexes)]
      index_previous = indexes[length(indexes)-1]
      previous_passing = previous_passing_list[[index]]
      
      ##
      # Get the neighbor list where we can go
      ##
      neighbors_list = neighbors_func(index, tess)
      
      ##
      # If we reach the end, do not move.
      ##
      if(neighbors_list$is_bound) {
        print("Reached a bound. End here.")
        new_passing = NA
        index_go = NA
        ##
        # If we can continue, apply the rule to know where to go
        ##
      } else {
        # Get the angle of each edge related to the previous position
        # 0 is current position, 0.1 is on the right, 0.9 is on the left
        neighbors = neighbors_list$neighbors
        neighbors$angle = angle(neighbors, index, index_previous, tess)
        # print(neighbors) 
        
        # Direction to go ("R", "L", etc., according to the rule)
        new_passing = rule_func(previous_passing, rule = rule)
        
        # Take the index according to where we must go
        index_go = rule_apply(neighbors, new_passing)
      }
      
      ##
      # Update index, previous_passing and stop
      ##
      if(is.na(index_go)) {
        stop = TRUE
      } else {
        stop = FALSE
        indexes = c(indexes, index_go)
        previous_passing_list[[index]] = c(previous_passing, new_passing)
      }
      
      ##
      # Plotting on the R dev
      ##
      if(!stop) {
        # Value of the cell
        nb_passing = length(previous_passing_list[[index]])
        value = value_modulo(nb_passing, modulo)
        
        # Update the graph on the R-session dev
        plot_polygon(vp, index, value, colmax = colmax)
      }
      
      ##
      # Exporting to png
      ##
      is_plot = is_current_to_plot(when_plot, iteration, max_iterations, stop)

      if(is_plot) {
        # Output file for this iteration
        iteration <<- iteration
        out_file = output_file(output_shape)
        dev_copy(out_file, size_png)
      }
    }
  }
}

tesselation_and_walk = function(seed, N, m, debug_plot,
                                closest, n,
                                from, e,
                                output_shape, max_iterations, rule, modulo, colmax,
                                when_plot, size_png) {
  ######################
  # Create tesselation #
  ######################
  ##
  # Periodic Voronoi
  ##
  set.seed(seed)
  z = simulation_square(N)
  
  
  z = (exp((2*1i*(1:N)*pi)/N))/3
  # z = c(0, apply(expand.grid(z, 1:m), 1, prod))
  z = c(apply(expand.grid(z, 1:m), 1, prod))
  m = 0
  
  
  
  tess = create_tiling(z, m, debug_plot)
  
  ##
  # Plot background of the walk 
  ##
  # Background of the walk:
  #   without the general shape
  # plot(c(1,1), xlim = vp@bbox[1,], ylim = vp@bbox[2,], 
  #      type = "n", xlab = "x", ylab = "y")
  #   with the shape
  vp = voronoipolygons(tess)
  plot(vp, border = "#555555")
  
  ##
  # Index init and previous
  ##
  index_init = index_init_func(tess, closest = closest, n = n)
  # Number of edges around the selected initial cell
  E = nrow(neighbors_func(index_init, tess)$neighbors)
  index_previous_init = index_previous_func(tess, index_init, e = e, from = from)
  
  ##
  # Perform walk
  ##
  if(!is.na(index_previous_init)) {
    perform_walk(index_previous_init, index_init,
                 tess, vp,
                 output_shape, max_iterations, rule, modulo, colmax,
                 when_plot, size_png)
  }
}