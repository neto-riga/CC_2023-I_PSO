using Dates
include("pso_func.jl")

inicial = now()

d = 2
a = [-5, -5]
b = [10, 10]
Part_N = 1000
Max_iter = 1000
res = pso(d, a, b, Part_N, Max_iter)

final = now()
println((final - inicial))

