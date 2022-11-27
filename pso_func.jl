using Distributions
using Statistics
include("funcion1d_1.jl")

function pso(d, l, u, Part_N=50, Max_iter=1000)
  x = l[1] .+ rand(Uniform(0,1), Part_N,d) .* (u[1] - l[1])
  obj_func = zeros(1,Part_N)
  for i = 1:Part_N
    obj_func[i] = funcion1d_1(x[i])
  end

  glob_opt = minimum(obj_func)
  ind = argmin(obj_func)[2]

  G_opt = x[ind] .* ones(Part_N,d)

  Mejor_pos = [x[ind]]

  Loc_opt = x

  v = zeros(Part_N,d)

  t = 1

  Nva_obj_func = zeros(1,Part_N)
  Evol_func_obj = zeros(1,Max_iter)
  while t < Max_iter
    v = v .+ rand(Uniform(0,1), Part_N,d) .* (Loc_opt - x) + rand(Part_N,d) .* (G_opt - x)
    x = x .+ v

    for i=1:Part_N
      if x[i] > u[1]
        x[i] = u[1]
      elseif x[i] < l[1]
        x[i] = l[1]
      end
      Nva_obj_func[i] = funcion1d_1(x[i])
      if Nva_obj_func[i] < obj_func[i]
        Loc_opt[i] = x[i]
        obj_func[i] = Nva_obj_func[i]
      end
    end
    #[Nvo_glob_opt,ind] = min(obj_func);
    Nvo_glob_opt = minimum(obj_func)
    ind = argmin(obj_func)[2]

    if Nvo_glob_opt < glob_opt
      glob_opt = Nvo_glob_opt
      #G_opt[:] = x[ind];
      G_opt[:] = x[ind] .* ones(Part_N,d)
      Mejor_pos = [x[ind]]
    end
    Evol_func_obj[t] = glob_opt
    t = t + 1;
  end
  # println(Mejor_pos)
  return Mejor_pos
end
