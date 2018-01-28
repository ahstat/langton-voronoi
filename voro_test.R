###
# Voronoi Langton tilling.
# Current: 2016/11/23
# Notes: Schläfli, Voronoi, tillings
#
# Main remarks for evolution with periodic Voronoi:
# N=1: always classic ant
#
# N=2: 'always' go up-left with RL rules and down_to_up initialization 
#
# N=3: 'always' unbounded, with a straight or snake evolution
# Can go to the left (seed 1, 27), up-left (205), up (3, 25, 110),
#   a-little-left-down (59), right (9), but no other direction.
#
# N=4: as 3, but also includes some bounded evolution with seed
#   seeds 47, 60, 80, 94, 126, 229, 234, 236
#
# N=5: snake loops, which may include a non-connected path
#
# N=6: non-connected bounded path for seed 9; go up-right with seed 87
#
# N=7: bounded with 81, some beautiful snakes.
#
# N=8,9,10: no more behavior observed.
##

#############
# Libraries #
#############
rm(list=ls())
library(deldir) # for Voronoi
library(sp) # for polygon
library(dismo) # for polygon
setwd("C:/Users/Administrator/Desktop/voro/voro")
# source("helpers/helpers.R")
source("helpers/output_shape.R")
source("helpers/create_voronoi_tiling.R")
source("helpers/plotting.R")
source("helpers/get_neighbors.R")
source("helpers/initialization.R")
source("helpers/angle.R")
source("helpers/rules.R")
source("helpers/perform_walk.R")

#################################
# Create tesselation parameters #
#################################
##
# Periodic Voronoi
##
# We draw N points uniformely in [-0.5,0.5]x[-0.5,0.5]
N = 2

# Plotted according to a seed
seed = 60

# Number of copy of the square in the four directions
#  to finally have points on [-m-0.5,m+0.5]x[-m-0.5,m+0.5]
# We can also control to have [-m_left-0.5,m_right+0.5]x[-m_down-0.5,m_up+0.5]
m = 2
# m = 9
# m = c(-2, 3, -1, 1) # m_left / m_right / m_down / m_up

##############################################
# Rule of the ant and max length of the walk #
##############################################
# "R"  = go right (smallest positive angle),
# "L"  = go right (highest angle),
# "B"  = go back (zero angle),
# "S"  = go straight (angle closest to 0.5),
# "2R" = go the second to the right, etc. ("3L", "5R", etc.)
rule = "R L" # right then left rule = "R L B" 

# max_iterations = 49 #
max_iterations = 500 #

#############################
# Initialization of the ant #
#############################
##
# The initial cell of the ant
##
# Method 1:
# We can select the cell where its center is the closest to (0,0)
#
#closest = TRUE
#n = NULL

# Method 2:
# We can find the cells with center in [-0.5,0.5]^2. By definition,
#  if we selected periodic Voronoi there is N cells like this.
# So we can select one of those N cells (indexed with n)
#
closest = FALSE
n = 1 # from 1 to N

##
# The cell from which cell we initially came
## 
# Method 1:
# We can select from the mean value of edges of the cell index_init,
#   take the lowest Im (which should be the "lowest" edge)
#
# from = "bottom_to_up"
# e = NULL

# Method 2:
# We can select all of the E cells around the cell index_init,
#   (indexed with e)
# No error is the e is too large (just skip, no computation)
from = NULL
e = 1 # from 1 to E, E is not known exactly (depend of the tesselation)

#############################
# Shape plotting parameters #
#############################
##
# Value of the cell where the ant is
##
# One new color each time the ant walk on the cell
# modulo = +Inf 

# Number of colors is according to the rule
modulo = length(strsplit(rule, " ")[[1]])

##
# Maximum number of color 
# (the lower, the easier to see differences between colors)
##
colmax = min(modulo, 50)

# modulos = c(+Inf, 2, 3, 4)
modulos = c(2)
colmaxs = sapply(modulos, function(modulo) {min(modulo, 50)})

#############################
# General output parameters #
#############################
##
# Debug plot only in the R session
##
debug_plot = TRUE

##
# Size of the png
##
size_png = 1200 # size_png x size_png

##
# Shape of the output (linked with function output_file)
##
# If we compute all iterations for the seed:
# output_shape = "out/N/seed/iteration.png"

# This is better to reduce number of folders if we only compute iteration_max:
output_shape = "out/N/seed_n/iteration.png"

##
# When to plot
##
# At each iteration
#
when_plot = "each_iteration"

# Only at the final iteration
#
# when_plot = "final_iteration"

######################################
# Tesselation, walk, plot and output #
######################################
for(N in 2:2) {
  print(N)
  for(seed in 1:100) {
    print(seed)
    for(n in 1:N) {
      print(n)
      for(e in 1:1) {
        for(idx_modulo in 1:length(modulos)) {
          modulo = modulos[idx_modulo]
          colmax = colmaxs[idx_modulo]
          tesselation_and_walk(seed, N, m, debug_plot,
                               closest, n,
                               from, e,
                               output_shape, max_iterations, rule, modulo, colmax,
                               when_plot, size_png)
        }
      }
    }
  }
}
