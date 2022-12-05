## Contenido
La carpeta contiene dos documentos:
- [resultados_secuencial.txt](https://github.com/neto-riga/CC_2023-I_PSO/blob/main/results/resultados_secuencial.txt) para los resultados de los tiempos de forma secuencial.
- [resultados_mpi.txt](https://github.com/neto-riga/CC_2023-I_PSO/blob/main/results/resultados_mpi.txt) para los resultados de los tiempos de forma secuencial.

## Resultados
### Secuencial
Comando para generar los tiempos de ejecución:
```bash
for run in {1..10}; do julia tiempo_secuencial.jl >> resultados_secuencial.txt; done;
```
Para 10 iteraciones obtuvimos:

| Iteración | Tiempo (ms) |
| --------- | ----------- |
| 1         | 5101        |
| 2         | 5161        |
| 3         | 5138        |
| 4         | 5132        |
| 5         | 5427        |
| 6         | 5089        |
| 7         | 5044        |
| 8         | 5054        |
| 9         | 5098        |
| 10        | 5042        |
|           |             |
| $\mu$     | 5128.6      |
| $\sigma$  | 106.621     |

Por lo que podemos estimar: $5128.6 \pm 208.97 \text{ms}$.

### Paralelizado con MPI
Comando utilizado para generar las primeras 24 líneas del documento:
```bash
for run in {1..12}; do mpiexec -n 12 julia pso_mpi.jl >> resultados_mpi.txt; done;
```
| Iteración | Tiempo (ms) | Aproximación      | $\varepsilon_{abs}$ |
| --------- | ----------- | ----------------- | ------------------- |
| 1         | 5443        | [1.0810,  1.1681] | 0.1866              |
| 2         | 5470        | [0.9961,  0.9924] | 0.0084              |
| 3         | 8691        | [0.9830,  0.9691] | 0.03518             |
| 4         | 8280        | [1.0030,  1.0037] | 0.0048              |
| 5         | 8898        | [0.9603,  0.9187] | 0.0903              |
| 6         | 8059        | [1.0897,  1.1818] | 0.2027              |
| 7         | 7470        | [0.9893,  0.9771] | 0.0251              |
| 8         | 8858        | [1.0629,  1.1305] | 0.1449              |
| 9         | 5710        | [0.9825,  0.9643] | 0.0396              |
| 10        | 5507        | [1.0192,  1.0421] | 0.0463              |
| 11        | 5432        | [0.9732,  0.9427] | 0.0632              |
| 12        | 5460        | [0.9576,  0.9162] | 0.0938              |
|           |             |                   |                     |
| $\mu$     | 6939.83     | -                 | 0.07279             |
| $\sigma$  | 1481.5508   | -                 | 0.06490             |

Por lo que podemos estimar tiempos de ejecución de: $6939.83 \pm 2903.838 \text{ms}$ para el tiempo y un error absoluto de: $0.07279 \pm 0.10384$.

### Eficiencia
Cuando se realiza PSO de forma secuencial, todas las partículas se ven atraídas a un solo punto, el mejor de todos, sin embargo, este punto puede ser el menor local, no el global. Cuando se realiza PSO paralelizando *enjambres* cada enjambre puede encontrar diferentes mínimos globales sin afectarse entre ellos, esto hace el algorítmo más enriquecedor y por lo tanto tiene una mejor precisión sin dejar de lado la eficiencia, pues a pesar de utilizar múltiples enjambres, todos se trabajan de manera simultánea.