##
# One dimension tilling
##
# ====x[1]===x[2]====================x[3]===x[4]====
# Can the tilling [x[1];x[2]],  [x[2];x[3]], [x[3];x[4]]
#   be represented through Voroinoi centers?
# x[k] = (v[k] + v[k+1])/2
# 
# No with this example:
x = c(0, 1, 100, 101)
N = length(x)

v = rep(NA, N+1)
v[1] = "v"
v_temp = rep(NA, N+1)
v_temp[1] = 0

for(k in 1:N) {
  v_temp[k+1] = 2*x[k] - v_temp[k]
  v[k+1] = paste(2*x[k], "-(", v[k], ")")
}

sign = (-1)^(1:N+1)
sign = gsub("-1", "-", sign)
sign = gsub("1", "+", sign)
v = paste(round(v_temp,3), sign, "v")
v[1] = "v"

for(i in 1:N) {
  print(paste(v[i], "<", x[i]))
  # print(paste(x[i], "<", v[i+1])) # repeat of the previous, no need
}
