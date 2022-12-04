# Particle Swarm Optimization (PSO) paralell implementation using Julia's wraper for MPI 
*Integrantes*:
  - Cázares Trejo Leonardo Damión
  - Rivera Gálvez Ernesto

### Objetivo:
- Implementar el algorítmo de optimización PSO de forma secuencial.
- Implementar el algorítmo de optimización PSO de forma paralela.
- Comparar el tiempo de ejecución de ambas implementaciones.
- Evaluar el error de nuestra implementación en paralelo.

Para más informción sobre el algorítmo consultar la carpeta *DOCS*, en ella se encuentra el modelo matemático y documentación del modelo.

### Modelo Secuencial
El modelo secuencial se encuentra implementado en el documento [pso_func.jl](https://github.com/neto-riga/CC_2023-I_PSO/blob/main/pso_func.jl), este a su vez, depende del documento [funciones.jl](https://github.com/neto-riga/CC_2023-I_PSO/blob/main/funciones.jl) que contiene las funciones sobre las que se trabajaron para encontrar el mínimo global. 

En especial, se encuentra la función de **Rosenbrock**, esta función se puede definir en $\mathbb{R}^n$