function func_cuad_d2(x)
  return (x[1] - 3)^2 + (x[2] - 5)^2
end

function rosenbrock(x, d)
  res = 0
  for i = 1:d-1
    res += 100*(x[i+1]-x[i]^2)^2 + (1-x[i])^2
  end
  return res  
end
