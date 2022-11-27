using MPI
include("pso_func.jl")
include("funcion1d_1.jl")

MPI.Init()
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
size = MPI.Comm_size(comm)

a = -6
b = 6
d = 1
intervalo = (b-a) / size

a_actual = a + rank*intervalo
b_actual = a_actual + intervalo

min_act = pso(d, [a_actual], [b_actual])

if rank != 0
  MPI.send(min_act, comm; dest=0, tag=0)
else
  RES_MIN = zeros(d)
  for i = 1:size-1
    mssgrcv = MPI.recv(comm; source=i, tag=0)
    minimo = min(funcion1d_1(RES_MIN[1]), funcion1d_1(mssgrcv[1]))

    # Guardar mínimo
    if minimo == funcion1d_1(RES_MIN[1])
      global RES_MIN = RES_MIN
    else
      global RES_MIN = mssgrcv
    end
  end
end

if rank == 0
  println("El valor mínimo está en x=$(RES_MIN[1])")
end


MPI.Barrier(comm)
MPI.Finalize()
