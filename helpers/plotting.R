###################################
# Plotting background tesselation #
###################################
# From http://stackoverflow.com/questions/36919805/
# Plot the background area of a given tesselation
# Argument:
# - tess: tesselation to plot
voronoipolygons = function(tess) {
  w = tile.list(tess)
  polys = vector(mode='list', length=length(w))
  for(i in seq(along=polys)) {
    pcrds = cbind(w[[i]]$x, w[[i]]$y)
    pcrds = rbind(pcrds, pcrds[1,])
    polys[[i]] = Polygons(list(Polygon(pcrds)), ID=as.character(i))
  }
  SP = SpatialPolygons(polys)
  return(SP)
}

##
# Examples
##
# ## Checkerboard
# z = 0 + 0 * 1i
# m = 2
# space_out = 1
# # Plotting tesselation with center points
# tess = create_tiling(z, m, plot_points = TRUE, space_out)
# # Plotting background (only cells, without centers)
# plot(voronoipolygons(tess))
# 
# ## Pentagons
# N = 5
# m = 3
# z = (exp((2*1i*(1:N)*pi)/N))/3
# z = c(apply(expand.grid(z, 1:m), 1, prod))
# # Plotting tesselation with center points
# tess = create_tiling(z, m = 0, plot_points = TRUE)
# # Plotting background (only cells, without centers)
# plot(voronoipolygons(tess))

##############################
# Updating color of one cell #
##############################
# Update one cell color (the area inside a polygon) of the tesselation.
# Arguments:
# - vp: a SpatialPolygon object obtained from voronoipolygons(tess)
# - idx_cell: cell to fill (indexed according to vp@polygons, which is
# similar to tess$summary indexation)
# - value_cell: value for the cell to fill between 1 and colmax (it can
# be the number of times the ant walked in this cell)
# - col_func: a color ramp function, such that col_func(colmax) gives colmax
# colors.
# - colmax: maximum number of colors for this walk
plot_polygon = function(vp, idx_cell, value_cell, colfunc = NULL, colmax = 50) {
  if(is.null(colfunc)) {
    # http://stackoverflow.com/questions/13353213/
    # colfunc <- colorRampPalette(c("red","yellow","springgreen","royalblue"))
    colfunc <- colorRampPalette(c("royalblue","red"))
    # plot(rep(1,50), col=(colfunc(50)), pch=19,cex=2)
  }
  
  col_all = colfunc(colmax)
  if(value_cell > colmax) {
    stop("Color value is too high, need to increase colmax.")
    # col = col_all[colmax]
  } else {
    col = col_all[value_cell]    
  }
  
  # Plotting the polygon on the current plot device
  # Note: plot.new must be called before, for example with plot(vp)
  polygon(vp@polygons[[idx_cell]]@Polygons[[1]]@coords, col = col)
}

##
# Examples
##
# ## Checkerboard
# tess = create_tiling(z = 0, m = 2)
# vp = voronoipolygons(tess)
# 
# plot(vp)
# plot_polygon(vp, 1, 1, colmax = 2)
# plot_polygon(vp, 1, 2, colmax = 2)
# plot_polygon(vp, 2, 1, colmax = 2)
# plot_polygon(vp, 3, 1, colmax = 2)
# plot_polygon(vp, 13, 2, colmax = 2)
#   
# ## Pentagons
# N = 5
# m = 3
# z = (exp((2*1i*(1:N)*pi)/N))/3
# z = c(apply(expand.grid(z, 1:m), 1, prod))
# tess = create_tiling(z, m = 0)
# vp = voronoipolygons(tess)
# 
# plot(vp)
# plot_polygon(vp, 1, 1, colmax = 5)
# plot_polygon(vp, 1, 2, colmax = 5)
# plot_polygon(vp, 2, 1, colmax = 5)
# plot_polygon(vp, 3, 1, colmax = 5)
# plot_polygon(vp, 13, 3, colmax = 5)

################################################################
# Helper function: Copy plotting device and export it to a png #
################################################################
# Copy plotting device and export it to a png without shutting down original
# device. From http://www.cookbook-r.com/Graphs/Output_to_a_file/
# Arguments:
# - out_file: output file,
# - size_png: an integer for both height and width of the png image
dev_copy = function(out_file, size_png) {
  dev.copy(png, out_file, width=size_png, height=size_png)
  dev.off()      
}