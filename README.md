# TSPMetaExplorer

Esta librería tiene como objetivo permitir usar ciertas metaheurísticas para resolver el TSP. La metaheurísticas disponibles en esta librería son:
- Búsqueda Tabú.
- Templado simulado.
- Algoritmos genéticos.
- Optimización de la colonia de hormigas.

## Comenzando

Siguiendo estas instrucciones podrás usar esta librería en tu proyecto. 

### Instalación

Para instalar la librería ejecuta lo siguiente.

```
install.packages("devtools")
devtools::install_github("efds24/MetaTSP")
```

### Uso
Para usar la librería
```
# Cargar el paquete
library(MetaTSP)
```
#### Búsqueda tabú

La función `busqueda_tabu` implementa el algoritmo de **Búsqueda Tabú** para resolver el **Problema del Viajante de Comercio** (TSP).

##### **Parámetros de la función**:

- **matrizDistancias**: Una matriz cuadrada simétrica de distancias entre las ciudades, con ceros en la diagonal. El valor en la posición `(i, j)` representa la distancia entre la ciudad `i` y la ciudad `j`.
- **maxIteraciones**: El número máximo de iteraciones para el proceso de búsqueda.
- **permanenciaListaTabu**: El número de iteraciones en las que un movimiento permanece en la lista tabú, evitando que se repita.
- **maxIterSinMejora**: El número máximo de iteraciones sin encontrar una mejora en la solución.

##### **Valor de retorno**:

La función devuelve una lista con los siguientes componentes:
- **mejorSolucion**: La mejor ruta encontrada durante la ejecución.
- **mejorCoste**: El coste (distancia total) de la mejor ruta encontrada.
- **tiempoCPU**: El tiempo total que tardó en ejecutarse el algoritmo.
- **listaTabu**: La última lista tabú generada, que muestra los movimientos prohibidos.

##### Ejemplo de Uso

A continuación se presenta un ejemplo de cómo usar la función `busqueda_tabu`:

```r
# Cargar la librería
library(MetaTSP)

# Definir una matriz de distancias entre las ciudades
matrizDistancias <- matrix(c(0, 100, 174, 158, 135, 125, 74,
              100, 0, 110, 180, 160, 150, 108,
              174, 110, 0, 95, 119, 151, 105,
              158, 180, 95, 0, 28, 55, 88,
              135, 160, 119, 28, 0, 35, 62,
              125, 150, 151, 55, 35, 0, 49,
              74, 108, 105, 88, 62, 49, 0), 
            nrow = 7, ncol = 7, byrow = TRUE)

# Ejecutar la búsqueda tabú
resultados <- busqueda_tabu(
  matrizDistancias = matrizDistancias, 
  maxIteraciones = 100,
  permanenciaListaTabu = 5,   
  maxIterSinMejora = 10
)

# Mostrar los resultados
cat("Mejor ruta: ", toString(resultados$mejorSolucion), "\n")
cat("Costo de la mejor ruta: ", resultados$mejorCoste, "\n")
cat("Tiempo de ejecución: ", resultados$tiempoCPU, "segundos\n")
cat("Última lista tabú: ", toString(resultados$listaTabu), "\n")
```

#### Templado simulado

La función `templado_simulado` implementa el algoritmo de **Templado Simulado** para resolver el **Problema del Viajante de Comercio** (TSP).

##### **Parámetros de la función**:

- **matrizDistancias**: Una matriz cuadrada simétrica de distancias entre las ciudades, con ceros en la diagonal. El valor en la posición `(i, j)` representa la distancia entre la ciudad `i` y la ciudad `j`.
- **temperaturaInicial**: La temperatura inicial del templado simulado, que controla la probabilidad de aceptar soluciones peores al principio.
- **tasaEnfriamiento**: La tasa de enfriamiento de la temperatura, un valor entre 0 y 1 que determina la rapidez con que la temperatura disminuye.
- **temperaturaParada**: La temperatura mínima alcanzada para detener el algoritmo.
- **maxIteracionesSinCambios**: El número máximo de iteraciones sin encontrar mejoras en la solución.
- **maxIteraciones**: El número máximo de iteraciones por cada valor de temperatura.

##### **Valor de retorno**:

La función devuelve una lista con los siguientes componentes:
- **mejorSolucion**: La mejor ruta encontrada durante la ejecución.
- **mejorCoste**: El coste (distancia total) de la mejor ruta encontrada.
- **tiempoCPU**: El tiempo total que tardó en ejecutarse el algoritmo en segundos.
- **listaTemperaturas**: Un vector con las temperaturas utilizadas durante el proceso.
- **listaCostes**: Un vector con los costes (distancias) asociados a cada temperatura.
- **listaProbAceptacion**: Un vector con las probabilidades de aceptación de las soluciones en cada iteración.

##### Ejemplo de Uso

A continuación se presenta un ejemplo de cómo usar la función `templado_simulado`:

```r
# Cargar la librería
library(MetaTSP)

# Definir una matriz de distancias entre las ciudades
matrizDistancias <- matrix(c(0, 100, 174, 158, 135, 125, 74,
              100, 0, 110, 180, 160, 150, 108,
              174, 110, 0, 95, 119, 151, 105,
              158, 180, 95, 0, 28, 55, 88,
              135, 160, 119, 28, 0, 35, 62,
              125, 150, 151, 55, 35, 0, 49,
              74, 108, 105, 88, 62, 49, 0), 
            nrow = 7, ncol = 7, byrow = TRUE)

# Ejecutar el templado simulado
resultados <- templado_simulado(
  matrizDistancias = matrizDistancias, 
  temperaturaInicial = 40, 
  tasaEnfriamiento = 0.1, 
  temperaturaParada = 0,
  maxIteracionesSinCambios = 10, 
  maxIteraciones = 100
)

# Mostrar los resultados
cat("Mejor ruta: ", toString(resultados$mejorSolucion), "\n")
cat("Costo de la mejor ruta: ", resultados$mejorCoste, "\n")
cat("Tiempo de ejecución: ", resultados$tiempoCPU, "\n")
cat("Temperaturas: ", toString(resultados$listaTemperaturas), "\n")
cat("Costes: ", toString(resultados$listaCostes), "\n")
cat("Probabilidades de aceptación: ", toString(resultados$listaProbAceptacion), "\n")

```

#### Algoritmo genético

La función `algoritmo_genetico` implementa el algoritmo **Genético** para resolver el **Problema del Viajante de Comercio** (TSP).

##### **Parámetros de la función**:

- **matrizDistancias**: Una matriz cuadrada simétrica de distancias entre las ciudades, con ceros en la diagonal. El valor en la posición `(i, j)` representa la distancia entre la ciudad `i` y la ciudad `j`.
- **tamPoblacion**: El tamaño de la población que se utiliza en el algoritmo genético.
- **numGeneraciones**: El número de generaciones o ciclos que se ejecutarán en el algoritmo.
- **porcentajeElistismo**: El porcentaje de la población que se conserva de una generación a otra, asegurando que los mejores individuos no se pierdan.
- **maxIterSinCambios**: El número máximo de iteraciones sin mejoras en la solución.

##### **Valor de retorno**:

La función devuelve una lista con los siguientes componentes:
- **mejorSolucion**: La mejor ruta encontrada durante la ejecución del algoritmo.
- **mejorCoste**: El coste (distancia total) de la mejor ruta encontrada.
- **tiempoCPU**: El tiempo total que tardó en ejecutarse el algoritmo en segundos.
- **listaCostes**: Lista de los costes a lo largo de las generaciones.
- **listaDiversidad**: Lista de la diversidad de la población a lo largo de las generaciones. 

##### Ejemplo de Uso

A continuación se presenta un ejemplo de cómo usar la función `algoritmo_genetico`:

```r
# Cargar la librería
library(nombredelpaquete)

# Definir una matriz de distancias entre las ciudades
matrizDistancias <- matrix(c(0, 100, 174, 158, 135, 125, 74,
              100, 0, 110, 180, 160, 150, 108,
              174, 110, 0, 95, 119, 151, 105,
              158, 180, 95, 0, 28, 55, 88,
              135, 160, 119, 28, 0, 35, 62,
              125, 150, 151, 55, 35, 0, 49,
              74, 108, 105, 88, 62, 49, 0), 
            nrow = 7, ncol = 7, byrow = TRUE)

# Ejecutar el algoritmo genético
resultados <- algoritmo_genetico(
  matrizDistancias = matrizDistancias,
  tamPoblacion = 30, 
  numGeneraciones = 100,
  porcentajeElistismo = 0.5,
  maxIterSinCambios = 10 
)

# Mostrar los resultados
cat("Mejor ruta: ", toString(resultados$mejorSolucion), "\n")
cat("Costo de la mejor ruta: ", resultados$mejorCoste, "\n")
cat("Tiempo de ejecución: ", resultados$tiempoCPU, "\n")
cat("Histórico de costes: \n", toString(resultados$listaCostes), "\n")
cat("Histórico de diversidad: \n", toString(resultados$listaDiversidad), "\n")
```

#### Optimización de la colonia de hormigas

La función `optimizacion_colonia_hormigas` implementa el algoritmo de **Colonia de Hormigas** para resolver el **Problema del Viajante de Comercio** (TSP).

##### **Parámetros de la función**:

- **matrizDistancias**: Una matriz cuadrada simétrica de distancias entre las ciudades, con ceros en la diagonal. El valor en la posición `(i, j)` representa la distancia entre la ciudad `i` y la ciudad `j`.
- **numHormigas**: El número de hormigas que participan en la búsqueda de la solución.
- **maxIteraciones**: El número máximo de iteraciones del algoritmo.
- **tasaEvaporacion**: Tasa de evaporación de las feromonas, un valor entre 0 y 1 que controla la reducción de las feromonas.
- **alfa**: Parámetro alfa que controla la influencia de las feromonas en la toma de decisiones (un valor típico entre 1 y 5).
- **beta**: Parámetro beta que controla la influencia de las distancias en la toma de decisiones (un valor típico entre 1 y 5).

##### **Valor de retorno**:

La función devuelve una lista con los siguientes elementos:
- **mejorSolucion**: La mejor ruta encontrada por las hormigas.
- **mejorCoste**: El coste (distancia total) de la mejor ruta.
- **listaCosteMedio**: Una lista con el historial de costes a lo largo de las iteraciones.
- **matrizFeromonas**: La matriz de feromonas al final.
- **tiempoCPU**: El tiempo que tardó en ejecutarse el algoritmo en segundos.

##### Ejemplo de Uso

A continuación se presenta un ejemplo de cómo usar la función `optimizacion_colonia_hormigas`:

```r
# Cargar la librería
library(MetaTSP)

# Definir una matriz de distancias entre las ciudades
matrizDistancias <- matrix(c(0, 100, 174, 158, 135, 125, 74,
              100, 0, 110, 180, 160, 150, 108,
              174, 110, 0, 95, 119, 151, 105,
              158, 180, 95, 0, 28, 55, 88,
              135, 160, 119, 28, 0, 35, 62,
              125, 150, 151, 55, 35, 0, 49,
              74, 108, 105, 88, 62, 49, 0), 
            nrow = 7, ncol = 7, byrow = TRUE)

# Ejecutar la optimización
resultados <- optimizacion_colonia_hormigas(
  matrizDistancias = matrizDistancias, 
  numHormigas = 10,
  maxIteraciones = 100, 
  tasaEvaporacion = 0.5,
  alfa = 1.0,
  beta = 2.0
)

# Mostrar los resultados
cat("Mejor ruta: ", toString(resultados$mejorSolucion), "\n")
cat("Costo de la mejor ruta: ", resultados$mejorCoste, "\n")
```

## Contributing

Comprueba el archivo [CONTRIBUTING.md] para los detalles del código de conducta, y el proceso para mandarnos solicitudes de cambio.

## Authors

* **Elena Fernández** - *Trabajo inicial*

## Licencia

Este proyecto tiene licencia del MIT - mira el archivo [LICENSE.md](LICENSE.md) para más detalles

