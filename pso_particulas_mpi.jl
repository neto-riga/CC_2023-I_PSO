using MPI
using Distributions
using Statistics
include("funcion1d_1.jl")

MPI.Init()
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
size = MPI.Comm_size(comm)

d = 1
l = [-6]
u = [6]
Part_N=size-1
Max_iter=1000

if rank != 0
  x_ = l[1] .+ rand(Uniform(0,1), 1, d) .* (u[1] - l[1])
  v_ = [0]
  MPI.send(x_[1], comm; dest=0, tag=0)
else
  x = zeros(1, Part_N)
  obj_func = zeros(1, Part_N)

  for i = 1:Part_N
    x[i] = MPI.recv(comm; source=i, tag=0)
    obj_func[i] = funcion1d_1(x[i])
  end

  glob_opt = minimum(obj_func)
  ind = argmin(obj_func)[2]
  G_opt = x[ind] .* ones(Part_N, d)
  Mejor_pos = [x[ind]]
  Loc_opt = x
  Nva_obj_func = zeros(1, Part_N)
  Evol_func_obj = zeros(1, Max_iter)
end

t = 1
while t < Max_iter
  if rank == 0
    for i=1:Part_N
      MPI.send([Loc_opt[i], G_opt[i]], comm; dest=i, tag=0)
    end
  else 
    opt_ = MPI.recv(comm; source=0, tag=0)
    Loc_opt_ = opt_[1]
    G_opt_ = opt_[2]
    global v_ = v_ .+ rand(Uniform(0,1), 1, d) .* (Loc_opt_ - x_[1]) + rand(1, d) .* (G_opt_ - x_[1])
    global x_ = x_ .+ v_
    MPI.send(x_[1], comm; dest=0, tag=0)
  end

  if rank == 0
    for i=1:Part_N 
      global x[i] = MPI.recv(comm; source=i, tag=0)
    end
    for i=1:Part_N
      if x[i] > u[1]
        global x[i] = u[1]
      elseif x[i] < l[1]
        global x[i] = l[1]
      end
      global Nva_obj_func[i] = funcion1d_1(x[i])
      if Nva_obj_func[i] < obj_func[i]
        global Loc_opt[i] = x[i]
        global obj_func[i] = Nva_obj_func[i]
      end
    end
    #[Nvo_glob_opt,ind] = min(obj_func);
    global Nvo_glob_opt = minimum(obj_func)
    global ind = argmin(obj_func)[2]

    if Nvo_glob_opt < glob_opt
      global glob_opt = Nvo_glob_opt
      #G_opt[:] = x[ind];
      global G_opt[:] = x[ind] .* ones(Part_N,d)
      global Mejor_pos = [x[ind]]
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
