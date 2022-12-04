using Distributions
using Printf
using Statistics

#function funcion1d_1(x)
#    return 3*x^4 - 8*x^3 + 12*x^2 - 48*x + 25;
#end

# Numero de dimensiones en que se mueve nuestra partícula
d = 1

# Limite inferior del dominio en que se mueve cada particula
l = [0]

# Limite superior del dominio en que se mueve cada particula
u = [3]

# Numero maximo de iteraciones (condicion de paro)
Max_iter = 500

# Numero de particulas
Part_N = 100

# Inicializamos la posicion inicial de cada particula, ecuacion (1)
x = l[1] .+ rand(Uniform(0,1), Part_N,d) .* (u[1] - l[1])

# Evaluamos la funcion objetivo en cada particula
obj_func = zeros(1,Part_N)
for i = 1:Part_N
    obj_func[i] = funcion1d_1(x[i])
end

# Mejor valor global (minimo), valor e indice
glob_opt = minimum(obj_func)
ind = argmin(obj_func)[2]

# Vector de valores optimos
G_opt = x[ind] .* ones(Part_N,d)

# Mejor posicion global
Mejor_pos = [x[ind]]

# Mejor local de cada particula
Loc_opt = x

# Velocidades iniciales
v = zeros(Part_N,d)

# Contador de iteraciones
t = 1

# Arreglos para evaluaciones de las funciones y su evolucion a lo largo de las iteraciones
Nva_obj_func = zeros(1,Part_N)
Evol_func_obj = zeros(1,Max_iter)

# Mientras no se alcance la condicion de paro
while t < Max_iter

# Calcula la nueva velocidad, ecuacion (2)
global v = v .+ rand(Uniform(0,1), Part_N,d) .* (Loc_opt - x) + rand(Part_N,d) .* (G_opt - x);

# Obtenemos nueva posicion, ecuacion (3)
global x = x .+ v

# Para cada particula se verifica que no salgan de los limites l y u
for i=1:Part_N
if x[i] > u[1]
global x[i] = u[1];
elseif x[i] < l[1]
global x[i] = l[1];
end

# Se vuelven a evaluar las nuevas posiciones en la funcion objetivo
global Nva_obj_func[i] = funcion1d_1(x[i])

# Se comprueba si se actualizan los optimos locales
if Nva_obj_func[i] < obj_func[i]

# Actualiza optimo local
global Loc_opt[i] = x[i]

# Actualiza funcion objetivo
global obj_func[i] = Nva_obj_func[i]
end
end

# Obtiene el mejor valor global
global Nvo_glob_opt = minimum(obj_func)
global ind = argmin(obj_func)[2]

# Se verifica si se actualiza el optimo global
if Nvo_glob_opt < glob_opt

    # Se actulizan los valores optimos
    global glob_opt = Nvo_glob_opt;
    global G_opt[:] = x[ind] .* ones(Part_N,d)
    global Mejor_pos = [x[ind]]
end

# Almacena valores de funcion objetivo
global Evol_func_obj[t] = glob_opt

# Incrementa la iteracion
global t = t + 1;
end
