###########################
# Helper function: modulo #
###########################
# Take x %% modulo and outputs in {1, ..., modulo}. Return x if modulo = +Inf.
# Used to define color value of polygons, and modulo is typically
# the length of the rule: length(strsplit(rule, " ")[[1]])
# Arguments:
# - x: integer,
# - modulo: integer or +Inf
mod = function(x, modulo = +Inf) {
  if(is.infinite(modulo)) { 
    return(x)
  } else {
    # x %% modulo, but standing in {1, ..., modulo} (not from 0)
    return(1 + ((x-1) %% modulo))
  }
}

##
# Unit tests
##
checkEquals(mod(5, 5), 5)
checkEquals(mod(4, 5), 4)
checkEquals(mod(6, 5), 1)
checkEquals(mod(0, 5), 5)
checkEquals(mod(6, +Inf), 6)

######################################################
# Helper function: Should we plot current iteration? #
######################################################
# Given arguments, outputs whether the current iteration is plotted
# Arguments:
# - when_plot: either "each_iteration" or "final_iteration"
# - iteration: current iteration of the process
# - max_iteration: last iteration of the process
# - stop: whether we need to stop at the current iteration (for example
# having reached a border)
is_current_to_plot = function(when_plot, iteration, max_iterations, stop) {
  if(when_plot == "each_iteration") {
    boolean = TRUE
  } else if(when_plot == "final_iteration") {
    if(iteration == max_iterations || stop == TRUE) {
      boolean = TRUE
    } else {
      boolean = FALSE
    }
  }
  return(boolean)
}

##
# Unit tests
##
checkEquals(is_current_to_plot("each_iteration", 2, 5, FALSE), TRUE)
checkEquals(is_current_to_plot("final_iteration", 2, 5, FALSE), FALSE)
checkEquals(is_current_to_plot("final_iteration", 5, 5, FALSE), TRUE)
checkEquals(is_current_to_plot("final_iteration", 2, 5, TRUE), TRUE)

##########################################
# Main function: Perform walk of the ant #
##########################################
# Perform walk of one ant on a subspace of R^2 plane for a given tesselation.
# Arguments:
# - tess: tesselation,
# - vp: voronoi polygons,
# - index_init: initial cell index (see initialization.R for more info),
# - index_previous_init: cell index before the initial cell,
# - rule: rule of moves of the ant (see rules.R),
# - max_iterations: maximum number of moves of the ant,
# - modulo: number of color each cell can have before going back to zero,
# - colmax: maximum number of colors,
# - size_png: dimension of height and width output,
# - when_plot: whether we output plot at each iteration or for final iteration,
# - output_shape: shape of directory where png files should be written,
# - not_a_variable: elements of output_shape which are not variables.
perform_walk = function(tess, vp,
                        index_init, index_previous_init,
                        rule, max_iterations,
                        modulo, colmax, size_png, when_plot, 
                        output_shape, not_a_variable) {
  ##
  # Global variables for the walk
  ##
  # All the indexes from the begining
  indexes = c(index_previous_init, index_init)
  
  # For each cell, which directions have been selected before
  previous_moves_list = initialize_previous_moves(tess)
  
  # Stop or not at current iteration
  stop = FALSE
  
  ##
  # Perform computations
  ##
  for(iteration in 1:max_iterations) {
    if(!stop) {
      print(iteration)
      ##
      # Current position, previous position, and previous moves in the
      # current position.
      ##
      index = indexes[length(indexes)]
      index_previous = indexes[length(indexes)-1]
      previous_moves = previous_moves_list[[index]]
      
      ##
      # Get the neighbor list where we can go
      ##
      neighbors_list = neighbors_func(index, tess)
      
      ##
      # If we reach the end, do not move.
      ##
      if(neighbors_list$is_bound) {
        print("Reached a bound. End here.")
        new_move = NA
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
        new_move = rule_func(previous_moves, rule = rule)
        
        # Take the index according to where we must go
        index_go = rule_apply(neighbors, new_move)
      }
      
      ##
      # Update index, previous_moves and stop
      ##
      if(is.na(index_go)) {
        stop = TRUE
      } else {
        stop = FALSE
        indexes = c(indexes, index_go)
        previous_moves_list[[index]] = c(previous_moves, new_move)
      }
      
      ##
      # Plotting on the R dev
      ##
      if(!stop) {
        # Value of the cell
        nb_moves = length(previous_moves_list[[index]]) + 1
        value = mod(nb_moves, modulo)
        
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
        out_file = shape_output_file(output_shape, 
                                     not_a_variable = not_a_variable)
        dev_copy(out_file, size_png)
      }
    }
  }
}