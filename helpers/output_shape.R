# Only have to write a shape of the output to output in the desired
#  directory, as a function of the different parameters
split_func = function(x, element) {
  output = as.vector(rbind(x,rep(element, length(x))))
  return(output[1:(length(output)-1)])
}

split_element = function(splited, element) {
  splited = strsplit(splited, element, fixed = TRUE)
  splited = lapply(splited, split_func, element)
  splited = unlist(splited)
  return(splited)
}

eval_func = function(x, elements) {
  if(x %in% elements) {
    return(x)
  } else {
    return(eval(parse(text = x)))
  }
}

output_file = function(output_shape, only_folder = FALSE) {
  splited = output_shape
  elements = c("/", ".", "_") # to split
  non_variable = c("out", "png") # those are not variables
  
  for(elem in elements) {
    splited = split_element(splited, elem)
  }
  
  # Do not take the name of the file, just the folder
  if(only_folder == TRUE) {
    splited = splited[1:max(which(splited == "/"))]
  }
  
  output = sapply(splited, eval_func, c(elements,non_variable))
  output = paste(output, collapse = "")
  return(output)
}

##
# Examples
##
# output_shape = "out/N/seed/iteration.png"
# N=10; seed=20; iteration=2; output_file(output_shape)
# output_shape = "out/N/seed_iteration.png"
# N=10; seed=20; iteration=2; output_file(output_shape)

##
# Create files according to the directory
##
folder_create_func = function(out_file) {
  folder_create = unlist(strsplit(out_file, "/"))
  folder_create = folder_create[1:(length(folder_create))]
  for(i in 1:length(folder_create)) {
    folder_to_create = paste(folder_create[1:i], collapse = "/")
    dir.create(folder_to_create, showWarnings = FALSE)
  }
}