##
# Polygons and plotting
##
# http://stackoverflow.com/questions/36919805/r-how-to-color-voronoi-tesselation-by-data-value
voronoipolygons = function(z) {
  w = tile.list(z)
  polys = vector(mode='list', length=length(w))
  for (i in seq(along=polys)) {
    pcrds = cbind(w[[i]]$x, w[[i]]$y)
    pcrds = rbind(pcrds, pcrds[1,])
    polys[[i]] = Polygons(list(Polygon(pcrds)), ID=as.character(i))
  }
  SP = SpatialPolygons(polys)
  return(SP)
}

# To update the color of one cell (= one polygon)
# Update only one polygon
plot_polygon = function(vp, idx_cell, value_cell, colfunc = NULL, colmax = 50) {
  if(is.null(colfunc)) {
    # http://stackoverflow.com/questions/13353213/gradient-of-n-colors-ranging-from-color-1-and-color-2
    # colfunc <- colorRampPalette(c("red","yellow","springgreen","royalblue"))
    # plot(rep(1,50),col=(colfunc(50)), pch=19,cex=2)
    colfunc <- colorRampPalette(c("royalblue","red"))
  }
  
  col_all = colfunc(colmax)
  if(value_cell > colmax) {
    print("WARNING. Color too high, need to increase colmax.")
    col = col_all[colmax]
  } else {
    col = col_all[value_cell]    
  }
  
  polygon(vp@polygons[[idx_cell]]@Polygons[[1]]@coords, col = col)
}
# Example of the function plot_polygon
# tess computed from create_tiling function.
# vp = voronoipolygons(tess)
# plot_polygon(vp, idx_cell = 1, value_cell = 30)
# plot_polygon(vp, idx_cell = 2, value_cell = 40)
# plot_polygon(vp, idx_cell = 3, value_cell = 50)

##
# Cell value, which will be plotted after
##
# Index where we were before moving: 
#   index
# and the number of previous passing for this index after the move:
#   length(previous_passing_list[[index]])
# Here modulo is typically length(strsplit(rule, " ")[[1]])
value_modulo = function(nb_passing, modulo = +Inf) {
  if(is.infinite(modulo)) { 
    return(1 + nb_passing)
  } else {
    return(1 + (nb_passing %% modulo))
  }
}

##
# Copy the dev to a png
##
# Make a plot off the screen without shutting down device
# http://www.cookbook-r.com/Graphs/Output_to_a_file/
dev_copy = function(out_file, size_png) {
  dev.copy(png, out_file, width=size_png, height=size_png)
  dev.off()      
}

##
# When to plot
##
is_current_to_plot = function(when_plot,
                              iteration, max_iterations, stop) {
  if(when_plot == "each_iteration") {
    plot_current = TRUE
  } else if(when_plot == "final_iteration") {
    if(iteration == max_iterations || stop == TRUE) {
      plot_current = TRUE
    } else {
      plot_current = FALSE
    }
  }
  return(plot_current)
}