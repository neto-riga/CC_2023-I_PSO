using MPI
using Distributions
using Statistics
include("func_d2.jl")

MPI.Init()
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
size = MPI.Comm_size(comm)

d = 2
l = [0, 0]
u = [8, 8]
Part_N = size-1
Max_iter = 1000

if rank != 0
  x_ = l .+ rand(Uniform(0,1), d) .* (u - l)
  v_ = [0, 0]
  MPI.send(x_, comm; dest=0, tag=0)
else
  x = zeros(Part_N, d)
  obj_func = zeros(1, Part_N)

  for i = 1:Part_N
    x[i, :] = MPI.recv(comm; source=i, tag=0)
    obj_func[i] = func_cuad(x[i, :])
  end

  glob_opt = minimum(obj_func)
  ind = argmin(obj_func)[2]
  G_opt = reshape(x[ind, :], 1, d) * ones(d, Part_N)
  Mejor_pos = [x[ind, :]]
  Loc_opt = x
  Nva_obj_func = zeros(1, Part_N)
  Evol_func_obj = zeros(1, Max_iter)
end

t = 1
while t < Max_iter
  if rank == 0
    for i=1:Part_N
      MPI.send([Loc_opt[i, :], G_opt[i]], comm; dest=i, tag=0)
    end
  else 
    opt_ = MPI.recv(comm; source=0, tag=0)
    Loc_opt_ = opt_[1]
    G_opt_ = opt_[2]
    global v_ = v_ .+ rand(Uniform(0,1), d) .* (Loc_opt_ - x_) .+ rand(d) .* (G_opt_ .- x_)
    global x_ = x_ .+ v_
    MPI.send(x_, comm; dest=0, tag=0)
  end

  if rank == 0
    for i=1:Part_N 
      global x[i, :] = MPI.recv(comm; source=i, tag=0)
    end
    for i=1:Part_N
      if x[i, :] > u
        global x[i, :] = u
      elseif x[i, :] < l
        global x[i, :] = l
      end
      global Nva_obj_func[i] = func_cuad(x[i, :])
      if Nva_obj_func[i] < obj_func[i]
        global Loc_opt[i, :] = x[i, :]
        global obj_func[i] = Nva_obj_func[i]
      end
    end
    global Nvo_glob_opt = minimum(obj_func)
    global ind = argmin(obj_func)[2]

    if Nvo_glob_opt < glob_opt
      global glob_opt = Nvo_glob_opt
      global G_opt[:] = reshape(x[ind, :], 1, d) * ones(d, Part_N)
      global Mejor_pos = [x[ind, :]]
    end
    global Evol_func_obj[t] = glob_opt
  end

  global t += 1
end

if rank==0
  println(Mejor_pos)
end

MPI.Barrier(comm)
MPI.Finalize()
