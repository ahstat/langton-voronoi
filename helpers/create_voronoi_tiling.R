##
# Create the initial points in a square
##
# N: number of elements in the square [-0.5,0.5]x[-0.5,0.5], drawn according 
# the uniform distribution.
simulation_square = function(N) {
  # square unit uniform centred in 0
  z = runif(N) + 1i * runif(N) - 0.5 - 1i*0.5
  return(z)
}

##
# Create the repeated Voronoi tesselation from points
##
replicate_square = function(z, m) {
  # replication of the unit square on [-m-0.5,m+0.5]x[-m-0.5,m+0.5]
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

range_plot_func = function(z_periodic, space_out = 1) {
  space_out_range = c(-space_out, space_out)
  range_x = range(Re(z_periodic))+space_out_range
  range_y = range(Im(z_periodic))+space_out_range
  return(list(range_x=range_x, range_y=range_y))
}

tess_func = function(z_periodic, range_plot) {
  x = Re(z_periodic)
  y = Im(z_periodic)
  tess <- deldir(x, y, rw = unlist(range_plot))
  return(tess)
}

plot_z_periodic = function(z, z_periodic, range_plot) {
  plot(NA, 
       xlim = range_plot$range_x, 
       ylim = range_plot$range_y, 
       type = "n", xlab = "x", ylab = "y",
       main = "Main uniform sample (red) and replications (black)")
  lines(z_periodic, type = "p")
  lines(z, type = "p", col = "red")
}

# Create a periodic Voronoi
create_tiling = function(z, m, plot_points = FALSE, space_out = 1) {
  z_periodic = replicate_square(z, m)
  range_plot = range_plot_func(z_periodic, space_out)
  tess = tess_func(z_periodic, range_plot)
  if(plot_points == TRUE) {
    plot_z_periodic(z, z_periodic, range_plot)
    plot.deldir(tess, wpoints="real", wlines="tess",
                asp = 1, main = "Voronoi tesselation with center points")
    lines(z, type = "p", col = "red")
  }
  return(tess)
}