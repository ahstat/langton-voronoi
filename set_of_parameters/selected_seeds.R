modulo = 2
colfunc = colorRampPalette(c("royalblue","red"))
colmax = 2
size_png = 800
when_plot = "each_iteration"

adding = function(df, seeds, N, rule) {
  N = rep(N, length(seeds))
  rule = rep(rule, length(seeds))
  df = rbind(df, data.frame(rule, N, seeds))
  return(df)
}

############################################
# Many tesselations with translated shapes #
############################################
# N points are selected randomly in [-0.5, 0.5]^2 and are copied in all 
# directions, leading to (2*m+1)*(2*m+1)*N points in  [m-0.5, m+0.5]^2
m = 10

df = data.frame(seed = 1, N = 1, rule = 1)
df = df[-1,]

df = adding(df, c(3, 19, 67, 90), 4, "R L")
df = adding(df, c(82), 5, "R L")

df = adding(df, c(15), 4, "S L")

df = adding(df, c(41, 47, 60), 4, "S P")

df = adding(df, c(36, 63), 3, "S R")
df = adding(df, c(60), 4, "S R")

df$max_iterations = rep(2000, nrow(df))

for(i in 1:nrow(df)) {
  print(i)
  rule = as.vector(df[i,]$rule)
  N = df[i,]$N
  myseed = df[i,]$seed
  max_iterations = df[i,]$max_iterations
  
  set.seed(myseed)
  z = simulation_square(N)
  tess = create_tiling(z, m, plot_points = FALSE)
  n = 1
  index_init = index_init_func(tess, n = n)
  # E = nrow(neighbors_func(index_init, tess)$neighbors)
  from = 1
  index_previous_init = index_previous_func(tess, index_init, from = from)
  
  ## Shape of the output (linked with function shape_output_file)
  output_shape = "outputs/each_translated_shape/rule_N_seed_myseed/N_seed_myseed_iteration.png"
  not_a_variable = c("outputs", "each", "not", "translated", "shape", "seed", "png")
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

###############################################
# Many tesselations without translated shapes #
###############################################
# N points are selected randomly in [-0.5, 0.5]^2
m = 0

df = data.frame(seed = 1, N = 1, rule = 1)
df = df[-1,]

df = adding(df, c(5, 19, 22), 500, "R L")
df = adding(df, c(15, 18, 20, 23), 1000, "R L")
df = adding(df, c(58), 1500, "R L")
df = adding(df, c(2, 26, 27, 47, 86, 90), 2000, "R L")
df = adding(df, c(2), 3500, "R L")
df = adding(df, c(4, 9, 27, 83), 5000, "R L")

df = adding(df, c(24, 71, 74, 100), 500, "S L")
df = adding(df, c(9), 1000, "S L")
df = adding(df, c(8, 55, 95, 100), 5000, "S L")

df = adding(df, c(3, 4, 56, 77), 500, "S P")
df = adding(df, c(28), 1000, "S P")
df = adding(df, c(38), 1500, "S P")
df = adding(df, c(1, 11, 57), 5000, "S P")

df = adding(df, c(4, 11, 34, 75), 500, "S R")
df = adding(df, c(1, 7, 12, 57, 77, 78), 5000, "S R")

df$max_iterations = rep(2000, nrow(df))

for(i in 1:nrow(df)) {
  print(i)
  rule = as.vector(df[i,]$rule)
  N = df[i,]$N
  myseed = df[i,]$seed
  max_iterations = df[i,]$max_iterations

  set.seed(myseed)
  z = simulation_square(N)
  tess = create_tiling(z, m, plot_points = FALSE, space_out = 0.1)
  n = NULL
  index_init = index_init_func(tess, n = n)
  # E = nrow(neighbors_func(index_init, tess)$neighbors)
  from = 1
  index_previous_init = index_previous_func(tess, index_init, from = from)
  
  ## Shape of the output (linked with function shape_output_file)
  output_shape = "outputs/each_not_translated_shape/rule_N_seed_myseed/N_seed_myseed_iteration.png"
  not_a_variable = c("outputs", "each", "not", "translated", "shape", "seed", "png")
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