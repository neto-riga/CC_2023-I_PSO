# Particle Swarm Optimization (PSO) paralell implementation using Julia's wraper for MPI 
*Integrantes*:
  - Cázares Trejo Leonardo Damián
  - Rivera Gálvez Ernesto

### Contenido
- [Particle Swarm Optimization (PSO) paralell implementation using Julia's wraper for MPI](#particle-swarm-optimization-pso-paralell-implementation-using-julias-wraper-for-mpi)
    - [Contenido](#contenido)
    - [Objetivo:](#objetivo)
    - [Modelo Secuencial](#modelo-secuencial)
      - [Análisis de Tiempo](#análisis-de-tiempo)
      - [Análisis de Escalabilidad](#análisis-de-escalabilidad)
    - [Modelo Paralelizado con MPI](#modelo-paralelizado-con-mpi)
      - [Análisis de Tiempo](#análisis-de-tiempo-1)


### Objetivo:
- Implementar el algorítmo de optimización PSO de forma secuencial.
- Implementar el algorítmo de optimización PSO de forma paralela.
- Comparar el tiempo de ejecución de ambas implementaciones.
- Evaluar el error de nuestra implementación en paralelo.

Para más informción sobre el algorítmo consultar la carpeta *DOCS*, en ella se encuentra el modelo matemático y documentación del modelo.

### Modelo Secuencial
El modelo secuencial se encuentra implementado en el documento [pso_func.jl](https://github.com/neto-riga/CC_2023-I_PSO/blob/main/pso_func.jl), este a su vez, depende del documento [funciones.jl](https://github.com/neto-riga/CC_2023-I_PSO/blob/main/funciones.jl) que contiene las funciones sobre las que se trabajaron para encontrar el mínimo global. 

En especial, se encuentra la función de **Rosenbrock** definida en $\mathbb{R}^n$, esto nos permitirá probar nuestro algorítmo en cualquier dimensión. 

Para observar el tiempo que tarda de forma secuencial se encuentra el documento [tiempo_secuencial.jl](https://github.com/neto-riga/CC_2023-I_PSO/blob/main/tiempo_secuencial.jl), en el se definen los parámetros con los que se utilizará PSO para encontrar el mínimo de la dimensión de Rosenbrock y al final imprime el tiempo que tardó en ejecutarse. 

#### Análisis de Tiempo
Utilizando el siguiente comando en la terminal
```bash
for run in {1..10}; do julia tiempo_secuencial.jl >> resultados_secuencial.txt; done;
```
creamos un ciclo de 10 repeticiones en el que se ejecuta el script de julia y guarda cada tiempo de ejecución en [tiempo_secuencial.txt](https://github.com/neto-riga/CC_2023-I_PSO/blob/main/tiempo_secuencial.jl). Teniendo los siguientes tiempos de ejecución para la función de Rosenbrock de dos dimensiones en el intervalo (-5, 10) en x e y, 1000 partículas y 1000 iteraciones, observamos que:
- El **menor tiempo** de ejecución fue de 5042 ms
- El **mayor tiempo** de ejecución fue de 5427 ms
- Con un **promedio** de 5128.6 ms
- Una **desviación estándar** de 106.621 ms
  
Podemos resumir que en general, el tiempo de ejecución de nuestro algorítmo secuencial es de $5128.6 \pm 208.97 \text{ms}$, resultante del promedio con un error de 1.96 veces la desviación estándar.

#### Análisis de Escalabilidad
El algorítmo puede trabajar con cualquier número de partículas deseadas, como con cualquier número de iteraciones, sin embargo, hay límites físicos, como la memoria de la computadora o el tiempo de ejecución que hay que tomar en cuenta.

Al utilizar una función que puede estar definida en cualquier dimensión y haber generalizado nuestro algorítmo de optimización para trabajar en cualquier dimensión, podemos encontrar cualquier mínimo global dentro de un rango. Sin embargo, si se aumenta la dimensionalidad, recomendamos aumentar el número de partículas y de iteraciones para tener una buena aproximación, lo que produce un costo computacional muy alto y a su vez tiempos de ejecución mucho más prolongados por cada dimensión aumentada.

Esto hace que el algorítmo sea escalable en el número de partículas e iteraciones, así como la dimensión con la que se quiera trabajar.

### Modelo Paralelizado con MPI
Para poder paralilzar un algorítmo, primero hay que preguntarse si es posible y de ser así, qué partes son paralelizables. Podemos pensar en tres formas de hacerlo:
- Dividir el dominio de la función que queremos encontrar por partes iguales para cada hilo, que cada uno aplique PSO y el maestro encuentre el mínimo global de todos los mínimos locales encontrados.
- Asignar a cada partícula un hilo, que este calcule su velocidad y posición en cada iteración y el maestro evalúe la mejor posición.
- Que cada hilo aplique PSO, esto dividiendo el número de partículas en partes iguales. Que el maestro encuentre el mínimo de cada resultado.

En el primer escenario, en términos de escalabilidad, sería complicado dividir el dominio en partes iguales a cada hilo, además que cada uno tendría que aplicar PSO con muchas partículas e iteraciones, lo que haría el algorítmo muy costoso a medida que aumente la región de optimización o partículas.

En el segundo escenario el maestro tendría la tarea de juntar todas las posiciones y después evaluar la función objetivo y hacer el resto. Esto resulta muy ineficiente, pues cada hilo hace muy pocas operaciones y el maestro haría prácticamente todo el trabajo de forma secuencial, por lo que resultará mucho menos eficiente. Además tiene la gran limitante en escalabilidad, pues solo podríamos tener de número de partículas, el número de procesadores disponibles si se paraleliza por memoria distribuída.

El tercer escenario permite a cada hilo realizar la misma tarea y finalmente el maestro solo tendría que encontrar cuál fue el mínimo global de todos los mínimos locales encontrados. De esta forma esperamos que cada hilo tarde lo mismo que si lo hicieramos de forma secuencial y el tiempo de ejecución adicional solo será el que tarde el maestro en encontrar el mínimo. Es tan escalable como el secuencial y permite utilizar cualquier número de hilos. Por lo que tomaremos esta estrategía de paralelización.

Una vez que decidimos qué paralelizar, hay que decidir cómo hacerlo. En este caso utilizaremos un servidor con múltiples procesadores, por lo que es conveniente hacer una implementación con paralelización con memoria distribuída. Utilizaremos MPI para realizar el cometido, Julia cuenta con un wraper que permite utilizar MPI escribiendo código únicamente en Julia. Utilizando el wraper conseguimos la siguiente implementación [pso_mpi.jl](https://github.com/neto-riga/CC_2023-I_PSO/blob/main/pso_mpi.jl). Utiliza la función pso secuencial ya mencionada, que será la que ejecute cada hilo.

#### Análisis de Tiempo
Para compararlo con el secuencial, utilizaremos los mismos valores tomados en el secuencial, de igual forma ejecutaremos el siguiente comando en la terminal para utilizar