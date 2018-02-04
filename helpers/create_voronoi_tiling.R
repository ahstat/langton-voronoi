#####################################
# Sample initial points in a square #
#####################################
# Sample N points in a unit square.
#  Argument:
# - N: number of elements in the square [-0.5,0.5]x[-0.5,0.5], drawn according 
# to uniform distribution.
simulation_square = function(N) {
  # square unit uniform centered in 0
  z = runif(N) + 1i * runif(N) - 0.5 - 1i*0.5
  return(z)
}

##
# Unit tests
##
checkTrue(min(Re(simulation_square(100))) > -0.5)
checkTrue(max(Re(simulation_square(100))) < 0.5)
checkTrue(min(Im(simulation_square(100))) > -0.5)
checkTrue(max(Im(simulation_square(100))) < 0.5)

#####################################################################
# Tile a region of the plane by translating points in a unit square #
#####################################################################
# We have complex points z in a unit square and we translate them
# in all directions according to m.
# Arguments:
# - z: points in a unit square, assumed to be [-0.5,0.5]x[-0.5,0.5],
# - m: if m is a positive integer, translate z in all 4 directions with
# a move of 1, 2, 3, ..., m. Outputs points in [-m-0.5,m+0.5]x[-m-0.5,m+0.5].
#      if m is a vector of 4 integers, translate z horizontally according
# to m[1]:m[2] and vertically according to m[3]:m[4].
replicate_square = function(z, m) {
  if(length(m) == 1) {
    m_left = -m
    m_right = m
    m_down = -m
    m_up = m
  } else if(length(m) == 4) {
    m_left = m[1]
    m_right = m[2]
    m_down = m[3]
    m_up = m[4]
  } else {
    stop("m should be of size 1 or 4")    
  }
  
  size_x = m_left:m_right
  size_y = m_down:m_up
  
  z_periodic = apply(expand.grid(z, size_x, 1i*rev(size_y)), 1, sum)
  return(z_periodic)
}

##
# Examples
##
# plot(replicate_square(simulation_square(1), 2))
# plot(replicate_square(simulation_square(2), 2))
# plot(replicate_square(simulation_square(1), c(-1,2,-3,4)))

##
# Unit tests
##
m = 2
z_periodic = replicate_square(simulation_square(100), m)
checkTrue(min(Re(z_periodic)) > -m-0.5)
checkTrue(max(Re(z_periodic)) < m+0.5)
checkTrue(min(Im(z_periodic)) > -m-0.5)
checkTrue(max(Im(z_periodic)) < m+0.5)
m = c(-1,2,-3,4)
z_periodic = replicate_square(simulation_square(100), m)
checkTrue(min(Re(z_periodic)) > m[1]-0.5)
checkTrue(max(Re(z_periodic)) < m[2]+0.5)
checkTrue(min(Im(z_periodic)) > m[3]-0.5)
checkTrue(max(Im(z_periodic)) < m[4]+0.5)
rm(m, z_periodic)

#######################################
# x and y limits for the plotted area #
#######################################
# We compute the Voronoi tesselation *only in a region* of the plane.
# The considered range of the region is given by the following function.
# Arguments:
# - z_periodic: points to build the Voronoi tesselation,
# - space_out: outside space on each direction. This space allows us to be
# aware when the ant goes out the defined region
range_plot_func = function(z_periodic, space_out = 1) {
  space_out_range = c(-space_out, space_out)
  range_x = range(Re(z_periodic))+space_out_range
  range_y = range(Im(z_periodic))+space_out_range
  return(list(range_x=range_x, range_y=range_y))
}

##
# Unit tests
##
m = 2
space_out = 1
range_plot = range_plot_func(replicate_square(simulation_square(100), m),
                             space_out)
checkTrue(range_plot$range_x[1] > -m-0.5-space_out)
checkTrue(range_plot$range_x[2] < m+0.5+space_out)
checkTrue(range_plot$range_y[1] > -m-0.5-space_out)
checkTrue(range_plot$range_y[2] < m+0.5+space_out)

m = c(-1,2,-3,4)
space_out = 7
range_plot = range_plot_func(replicate_square(simulation_square(100), m), 
                             space_out)
checkTrue(range_plot$range_x[1] > m[1]-0.5-space_out)
checkTrue(range_plot$range_x[2] < m[2]+0.5+space_out)
checkTrue(range_plot$range_y[1] > m[3]-0.5-space_out)
checkTrue(range_plot$range_y[2] < m[4]+0.5+space_out)
rm(m, space_out, range_plot)

############################
# Debug plot of the points #
############################
# Plot points z (in a unit square) and translated points z_periodic.
# Arguments:
# - z: points in a unit square,
# - z_periodic: translated points,
# - range_plot: range for the plot
plot_z_periodic = function(z, z_periodic, range_plot) {
  plot(NA,
       xlim = range_plot$range_x, 
       ylim = range_plot$range_y, 
       type = "n", xlab = "x", ylab = "y",
       main = "Main uniform sample (red) and replications (black)")
  lines(z_periodic, type = "p")
  lines(z, type = "p", col = "red")
}

##
# Examples
##
# ## Example 1
# N = 1
# m = 2
# space_out = 3
# z = simulation_square(N)
# z_periodic = replicate_square(z, m)
# range_plot = range_plot_func(z_periodic, space_out)
# plot_z_periodic(z, z_periodic, range_plot)
# 
# ## Example 2
# N = 3
# m = 1
# space_out = 1
# z = simulation_square(N)
# z_periodic = replicate_square(z, m)
# range_plot = range_plot_func(z_periodic, space_out)
# plot_z_periodic(z, z_periodic, range_plot)

#################################################
# Compute the tesselation from points and range #
#################################################
# Compute the tesselation given arguments and outputs a deldir object.
# Arguments:
# - z_periodic: points to build the Voronoi tesselation,
# - range_plot: range of the plotting area
tess_func = function(z_periodic, range_plot) {
  x = Re(z_periodic)
  y = Im(z_periodic)
  tess <- deldir(x, y, rw = unlist(range_plot))
  return(tess)
}

##
# Examples
##
# ## Example 1
# N = 1
# m = 2
# space_out = 3
# z_periodic = replicate_square(simulation_square(N), m)
# range_plot = range_plot_func(z_periodic, space_out)
# tess = tess_func(z_periodic, range_plot) 
# plot.deldir(tess, wpoints="real", wlines="tess")
# 
# ## Example 2
# N = 3
# m = 1
# space_out = 1
# z_periodic = replicate_square(simulation_square(N), m)
# range_plot = range_plot_func(z_periodic, space_out)
# tess = tess_func(z_periodic, range_plot) 
# plot.deldir(tess, wpoints="real", wlines="tess")

#########################################
# Create a periodic Voronoi tesselation #
#########################################
# Given initial points in a unit square, compute the tilling.
# Arguments:
# - z: initial points in a unit square,
# - m: translation to apply in each 4 directions
# - plot_points: whether we plot the obtained tesselation
# - space_out: outside space on each direction
create_tiling = function(z, m, plot_points = FALSE, space_out = 1) {
  z_periodic = replicate_square(z, m)
  range_plot = range_plot_func(z_periodic, space_out)
  tess = tess_func(z_periodic, range_plot)
  if(plot_points == TRUE) {
    ## Plotting points used for tesselation
    plot_z_periodic(z, z_periodic, range_plot)
    ## Plotting tesselation
    plot.deldir(tess, wpoints="real", wlines="tess",
                asp = 1, main = "Voronoi tesselation with center points")
    lines(z, type = "p", col = "red")
  }
  return(tess)
}

##
# Examples
##
# ## Example 1
# N = 1
# z = simulation_square(N)
# m = 2
# space_out = 3
# create_tiling(z, m, plot_points = TRUE, space_out)
# 
# ## Example 2
# N = 3
# z = simulation_square(N)
# m = 1
# space_out = 1
# create_tiling(z, m, plot_points = TRUE, space_out)