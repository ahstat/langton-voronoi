##
# Voronoi tillings
##
# Schläfli
library(deldir)

size = -20:20
size_demi = unique(floor(size/2))

range_plot = range(size)+c(-2,2)

# Hexagon
pi = atan(1)*4
theta = pi/3
z = complex(argument = theta) 
z_barre = complex(argument = -theta) 

points_1 = apply(expand.grid(size, (z-z_barre)*size_demi), 1, sum)
points_2 = points_1 + z
points = c(points_1, points_2)

plot(NA, xlim = range_plot, ylim = range_plot, type = "n", xlab = "x", ylab = "y")

lines(points, type = "p")
lines(0+0i, type = "p", col = "red")
# 
x = Re(points)
y = Im(points)

range(size)

window <- rep(range_plot, 2)
tess <- deldir(x, y, rw = window)

plot.deldir(tess, wpoints="real", wlines="tess") 


# Triangles

plot(NA, xlim = c(-5,5), ylim = c(-5,5), col = "red", type = "n")
points(0+0i)


e_2ipi_6 = complex(argument = 2*pi/6)
e_2ipi_12 = complex(argument = 2*pi/12)

e_minus2ipi_3 + e_2ipi_12


e_2ipi_12
e_2ipi_12 + e_2ipi_6


rotate = function(k, N) {complex(argument = 2*(k*pi)/N)}

p1 = rotate(1, 12) - rotate(1, 12)
p2 = rotate(3, 12) - rotate(1, 12)
p3 = rotate(5, 12) - rotate(1, 12)
p4 = rotate(7, 12) - rotate(1, 12)
p5 = rotate(9, 12) - rotate(1, 12)
p6 = rotate(11, 12) - rotate(1, 12)
points(p1)
points(p2)
points(p3)
points(p4)
points(p5)
points(p6)


base = sqrt(3)/2
p1 = 0+0i
p2 = -base + 0.5i
p3 = -2*base + 0i
p4 = -2*base - 1i
p5 = -base - 1.5i
p6 = -1i
points(p1)
points(p2)
points(p3)
points(p4)
points(p5)
points(p6)

# # p1, 3, 4, 6 types
# k = -5:5
# x1 = 2*base*k # x
# # y11 = 2*k*1i + 0i
# # y12 = 2*k*1i - 1i
# y11 = 4*k*1i + 0i
# y12 = 4*k*1i - 1i
# y1 = c(y11, y12)
# 
# z1 = apply(expand.grid(x1, y1), 1, sum)
# points(z1)
# 
# # p2, 5 types
# k = -5:5
# x2 = base + 2*base*k
# y21 = 0.5i + 2*k*1i # y1
# y22 = -1.5i + 2*k*1i # y2
# y2 = c(y21, y22)
# z2 = apply(expand.grid(x2, y2), 1, sum)
# points(z2, col = "red")


# p1, 3, 4, 6 types
k = -5:5
x1 = 2*base*k # x
# y11 = 2*k*1i + 0i
# y12 = 2*k*1i - 1i
y11 = 3*k*1i + 0i
y12 = 3*k*1i - 1i
y1 = c(y11, y12)

z1 = apply(expand.grid(x1, y1), 1, sum)
points(z1)

# p2, 5 types
k = -5:5
x2 = base + 2*base*k
y21 = 0.5i + 3*k*1i # y1
y22 = -1.5i + 3*k*1i # y2
y2 = c(y21, y22)
z2 = apply(expand.grid(x2, y2), 1, sum)
points(z2, col = "red")

x = Re(c(z1, z2))
y = Im(c(z1, z2))

window <- c(-6,6,-6,6)
tess <- deldir(x, y, rw = window)

plot.deldir(tess, wpoints="real", wlines="tess") 


