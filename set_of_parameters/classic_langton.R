#########################
# Classic Langton's ant #
#########################
# As plotted in https://en.wikipedia.org/wiki/Langton's_ant
## Parameters
tess = create_tiling(z = 0, m = 6, plot_points = FALSE)
index_init = index_init_func(tess)
index_previous_init = index_previous_func(tess, index_init, "right_to_left")
rule = "R L"
max_iterations = 100
modulo = length(strsplit(rule, " ")[[1]])
colfunc = colorRampPalette(c("white","black"))
colmax = min(modulo, 50)
size_png = 800
when_plot = "each_iteration"
output_shape = "outputs/classic/iter_iteration.png"
not_a_variable = c("outputs", "classic", "iter", "png")
output_folder = shape_output_file(output_shape, only_folder = TRUE,
                                  not_a_variable = not_a_variable)
folder_create(output_folder)

## Background of the walk 
vp = voronoipolygons(tess)
plot(vp, border = "#555555")

## Walking
perform_walk(tess, vp,
             index_init, index_previous_init,
             rule, max_iterations,
             modulo, colfunc, colmax, size_png, when_plot, 
             output_shape, not_a_variable)