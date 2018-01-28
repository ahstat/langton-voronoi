# Pi
pi = atan(1)*4

##
# Modulo and find next index
##
# Modulo 1, this number between 0 and 1.
# The most close to 0, the most to the right to the current point
# The most close to 1, the most to the left to the current point.
#
# Technically: Arg between [-pi,pi], so result without %% between [-1,1],
#   then translated to the positive. We compute the relative angle of
#   the edge with respect to the position where we entered 
#
# Show Arg(-100 - 1i*1) - Arg(-100 + 1i*1)/(2*pi)
# and (Arg(-100 - 1i*1) - Arg(-100 + 1i*1)/(2*pi)) %% 1
angle = function(neighbors, index, index_previous, tess) {
  
  z_index = z_index_func(index, tess)
  # z_previous = z_index_func(index_previous, tess)
  z_edge_previous = neighbors$z_edge[which(neighbors$index == index_previous)]
  
  angle_out = ((Arg(neighbors$z_edge - z_index) - Arg(z_edge_previous - z_index))/(2*pi))
  angle_out[abs(angle_out)<10^-15] = 0 # sometimes, a-a=-10^-17 and then we get a %% 1 = 1.
  angle_out = angle_out %% 1
  return(angle_out)
}