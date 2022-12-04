### Contenido
En la carpeta se encuentran los archivos para implementar PSO de manera paralela en un conjunto de procesadores con memoria distribuída a través de MPI utilizando un wraper en Julia.

Los documentos son los siguientes:
- [funciones.jl](https://github.com/neto-riga/CC_2023-I_PSO/blob/main/main/funciones.jl) contiene las funciones para probar las implementacionse, en específico la función de Rosenbrock.
- [pso_func.jl](https://github.com/neto-riga/CC_2023-I_PSO/blob/main/main/pso_func.jl) implementa pso de manera secuencial como una función.
- [tiempo_secuencial.jl](https://github.com/neto-riga/CC_2023-I_PSO/blob/main/main/tiempo_secuencial.jl) script para evaluar el tiempo en que tarda en ejecutarse la PSO con ciertos parámetros.
- [pso_mpi.jl](https://github.com/neto-riga/CC_2023-I_PSO/blob/main/main/pso_mpi.jl) script para evaluar el tiempo que tarda en ejecutarse PSO utilizando MPI con los mismos parámetros.