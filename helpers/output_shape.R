##############################################################
# Helper function: Insert element between each position of x #
##############################################################
# Insert string 'element' between each position of vector 'x'
# Arguments:
# - x: character vector
# - element: element to insert between each position of x
insert_elem = function(x, element) {
  output = as.vector(rbind(x, rep(element, length(x))))
  return(output[1:(length(output)-1)])
}

##
# Unit tests
##
x = c("a", "b", "c")
element = "/"
checkEquals(insert_elem(x, element), c("a", "/", "b", "/", "c"))

x = c("N", ".", "/", "i")
element = "e"
checkEquals(insert_elem(x, element), c("N", "e", ".", "e", "/", "e", "i"))

x = "a"
element = "/"
checkEquals(insert_elem(x, element), "a")

x = ""
element = "/"
checkEquals(insert_elem(x, element), "")

rm(x, element)

##########################################################
# Helper function: Split x at each split, and keep split #
##########################################################
# Split string 'x' at each 'split' and keep split. 
# - x: string to split
# - split: split character
split_element = function(x, split) {
  x = strsplit(x, split, fixed = TRUE)
  x = lapply(x, insert_elem, split)
  x = unlist(x)
  return(x)
}

##
# Unit tests
##
x = "out/N/seed/iteration.png"
split = "/"
checkEquals(split_element(x, split),
            c("out", "/", "N", "/", "seed", "/", "iteration.png"))

x = "out/N/seed/iteration.png"
split = "."
checkEquals(split_element(x, split),
            c("out/N/seed/iteration", ".", "png"))

rm(x, split)

###############################################################
# Helper function /!\: Evaluate x unless it is not a variable #
###############################################################
# Evaluate 'x' unless it is is 'not_a_variable'
# Arguments:
# - x: element to evaluate, written as a string (for example "N" for N)
# - not_a_variable: vector of strings containing element which should not be
# evaluated.
eval_func = function(x, not_a_variable) {
  if(x %in% not_a_variable) {
    return(x)
  } else {
    if(!exists(x)) {
      stop("Target element of x must be defined!")
      # for example, if x = "N", N should be an existing
      # element, for example we have defined N = 10.
    }
    return(eval(parse(text = x)))
  }
}

##
# Unit tests
##
N = 10
out = NULL; rm(out)
M = NULL; rm(M)
checkEquals(eval_func("out", c("out", "/")), "out")
checkEquals(eval_func("N", c("out", "/")), N)
checkException(eval_func("M", c("out", "/")), silent = TRUE)
rm(N)

########################################################################
# Evaluate a shape by evaluating each element unless not variable ones #
########################################################################
# A shape can be an output directory such as the string "out/N/seed-iter.png"
# After having defined N, seed and iter, for example N=1, seed=3, iter=10,
# the function evaluates the string and outputs: "out/1/3-10.png".
# Split elements are defined ("/" and "." in this example),
# Not a variable elements are defined ("out" and "png" in this example)
# The argument only_folder allows to keep outputs up to the last "/", i.e.
# will output "out/1/"
# Arguments:
# - shape: string to evaluate
# - only_folder: whether we evaluate up to the last "/" element
# - elements: elements where the string is cut
# - not_a_variable: elements to keep as string without modification
shape_output_file = function(shape, only_folder = FALSE,
                             elements = c("/", ".", "_"),
                             not_a_variable = c("outputs", "png")) {
  split = shape
  
  for(elem in elements) {
    split = split_element(split, elem)
  }
  
  # Do not take the name of the file, just the folder
  if(only_folder == TRUE) {
    split = split[1:max(which(split == "/"))]
  }
  
  output = sapply(split, eval_func, c(elements, not_a_variable))
  output = paste(output, collapse = "")
  return(output)
}

##
# Unit tests
##
shape = "outputs/N/seed/iteration.png"
N=10; seed=20; iteration=2
checkEquals(shape_output_file(shape), "outputs/10/20/2.png")
checkEquals(shape_output_file(shape, TRUE), "outputs/10/20/")

shape = "outputs/N/pic_m.png"
N=11; m=2
not_a_variable = c("outputs", "pic", "png")
checkEquals(shape_output_file(shape, not_a_variable = not_a_variable),
            "outputs/11/pic_2.png")

rm(shape, N, seed, iteration, m, not_a_variable)

############################################################
# Create folder and inner folders according to a directory #
############################################################
# Given a directory, for example "out/subfolder/sub2", create the
# folder "out", then "out/subfolder", then "out/subfolder/sub2",
# so that file can be saved into this inner folder.
# Arguments:
# - directory: Inner directory where files should be saved
folder_create = function(directory) {
  folders = unlist(strsplit(directory, "/"))
  folders = folders[1:(length(folders))]
  for(i in 1:length(folders)) {
    folder_to_create = paste(folders[1:i], collapse = "/")
    dir.create(folder_to_create, showWarnings = FALSE)
  }
}
# ##
# # Example
# ##
# folder_create("outtest/test2/test3")