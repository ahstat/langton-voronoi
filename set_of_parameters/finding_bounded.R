max_seed = 10000
max_iterations = 1000
N = 400

rules = c("S P", "R L", "S R", "S L")
modulo = 2
colfunc = colorRampPalette(c("royalblue","red"))
colmax = 2
size_png = 800
when_plot = "final_iteration"


###############################################
# Many tesselations without translated shapes #
###############################################
# N points are selected randomly in [-0.5, 0.5]^2
m = 0

for(rule in rules) {
  print(rule)
  for(myseed in 1:max_seed) {
    print(paste("seed", myseed))
    set.seed(myseed)
    z = simulation_square(N)
    tess = create_tiling(z, m, plot_points = FALSE, space_out = 0.1)
    n = NULL
    index_init = index_init_func(tess, n = n)
    # E = nrow(neighbors_func(index_init, tess)$neighbors)
    from = 1
    index_previous_init = index_previous_func(tess, index_init, from = from)
    
    ## Shape of the output (linked with function shape_output_file)
    output_shape = "outputs/finding_bounded/rule/iteration_seed_myseed.png"
    not_a_variable = c("outputs", "finding", "bounded", "seed", "png")
    output_folder = shape_output_file(output_shape, only_folder = TRUE,
                                      not_a_variable = not_a_variable)
    folder_create(output_folder)
    
    vp = voronoipolygons(tess)
    plot(vp, border = "#555555")
    
    ## Walking
    perform_walk(tess, vp,
                 index_init, index_previous_init,
                 rule, max_iterations,
                 modulo, colfunc, colmax, size_png, when_plot, 
                 output_shape, not_a_variable)
  }
}
