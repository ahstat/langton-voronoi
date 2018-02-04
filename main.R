###################################################################
# Langton-Voronoi : Langton's ant extended to Voronoi tesselation #
# 2016/11/01 - 2018/02/04                                         #
###################################################################
# Classic Langton's ant is described in en.wikipedia.org/wiki/Langton's_ant
#
# In this code, novelty is to extend this process to any tesselation obtained
# from Voronoi points.
#
# Extension to multiple colors is done (we can select standard "R L" rule or 
# any other self-defined rule).
#
# Extension to multiple states (turmite), multiple ants, or higher dimensions
# is *not* done.
rm(list=ls())
library(deldir) # for deldir and plot.deldir
library(sp) # for voronoipolygons
library(RUnit) # for unit tests
setwd("E:/gitperso/langton-voronoi/")
source("helpers/create_voronoi_tiling.R")
source("helpers/get_neighbors.R")
source("helpers/initialization.R")
source("helpers/angle.R")
source("helpers/rules.R")
source("helpers/output_shape.R")
source("helpers/plotting.R")
source("helpers/perform_walk.R")
# Recommanded order to read source code (with principal functions)
# 1- 'create_voronoi_tiling.R' ('simulation_square', 'create_tiling')
# 2- 'get_neighbors.R' ('neighbors_func')
# 3- 'initialization.R' ('index_init_func', 'index_previous_func')
# 4- 'angle.R' ('angle')
# 5- 'rules.R' ('rule_func', 'rule_apply')
# 6- 'output_shape.R' ('shape_output_file', 'folder_create')
# 7- 'plotting.R' ('voronoipolygons', 'plot_polygon')
# 8- 'perform_walk.R' ('perform_walk')

################
################
## Parameters ##
################
################

###############
# Tesselation #
###############
# We draw N points uniformely in [-0.5,0.5]x[-0.5,0.5]
# Then, we translate and copy those N points in the four directions by
# step of 1 up to m to finally have N*(2*m+1)^2 points in 
# [-m-0.5,m+0.5]x[-m-0.5,m+0.5].
N = 3
m = 2
seed = 6
set.seed(seed)
z = simulation_square(N)
tess = create_tiling(z, m, plot_points = TRUE)
rm(m, z)
# Note: we can also control directions to have points in
# [-m_left-0.5,m_right+0.5]x[-m_down-0.5,m_up+0.5]:
# m = c(-2, 3, -1, 1) # m_left / m_right / m_down / m_up

## Checking the edge length of the tesselation
if(min(distance_of_edges(tess$dirsgs)) < 0.01) {
  warning("At least one edge is difficult to see with human eye")
}

#############################
# Initialization of the ant #
#############################
## The initial cell (t = 1)
# By default, we select the cell with center closest to (0,0)
n = NULL
# We can select any other cell in [-0.5,0.5]^2 (indexed by 1:N): n=1, n=2, etc.
index_init = index_init_func(tess, n = n)

## The previous cell (t = 0)
# By default, we select previous cell at the bottom of the initial cell
from = "bottom_to_up"
# We can also select "up_to_bottom", "left_to_right", "right_to_left"
# We can also select any neighbor cell of the initial cell (indexed by 1:E),
# e=1, e=2, etc. In this case, E depends of the considered tesselation:
# E = nrow(neighbors_func(index_init, tess)$neighbors)
index_previous_init = index_previous_func(tess, index_init, from = from)

###################
# Rule of the ant #
###################
## Moving rule
# "R"  = go right (smallest positive angle),
# "L"  = go left (highest angle),
# "B"  = go back (zero angle),
# "S"  = go straight (angle closest to 0.5),
# "2R" = go the second to the right, etc. ("3L", "5R", etc.)
rule = "R L" # default rule: right, then left 
# rule = "R L B" # right, then left, then go backwards.

## Number of iterations (stop before if the ant reaches a border)
max_iterations = 100

########################
# Plotting and outputs #
########################
## Number of colors before going back to first color
modulo = length(strsplit(rule, " ")[[1]]) # according to the rule
# modulo = +Inf # one new color each time the ant walk on the cell

## Maximum number of color 
# (the lower, the easier to see differences between colors)
colmax = min(modulo, 50)

## Size of the png (height = size_png ; width = size_png)
size_png = 800

## When to output the plot? (at "each_iteration" or only at "final_iteration")
when_plot = "each_iteration"

## Shape of the output (linked with function shape_output_file)
output_shape = "outputs/test/iter_iteration.png"
# output_shape = "outputs/N/seed/iteration.png"
not_a_variable = c("outputs", "test", "iter", "png")
output_folder = shape_output_file(output_shape, only_folder = TRUE,
                                  not_a_variable = not_a_variable)
folder_create(output_folder)
rm(output_folder)
# Note: It is better to reduce number of folders if when_plot="final_iteration"

####################
####################
## Launch the ant ##
####################
####################

## Background of the walk 
vp = voronoipolygons(tess)
plot(vp, border = "#555555")

## Walking
perform_walk(tess, vp,
             index_init, index_previous_init,
             rule, max_iterations,
             modulo, colmax, size_png, when_plot, 
             output_shape, not_a_variable)