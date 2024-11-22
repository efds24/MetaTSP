# Clase Core para resolver el problema del viajante de comercio (TSP)
#
# Implementa la lógica central para el problema del viajante de comercio:
#  - Función objetivo para evaluar soluciones.
#  - Generación de una solución inicial.

crear_core_tsp <- function(matrizDistancias) {
  # Validar la matriz
  numCiudades <- nrow(matrizDistancias)
  if (!all(diag(matrizDistancias) == 0)) {
    stop("La diagonal de la matriz de distancias debe contener ceros.")
  }
  if (any(matrizDistancias[upper.tri(matrizDistancias)] <= 0)) {
    stop("La matriz no puede tener ceros (salvo en la diagonal) o valores negativos.")
  }

  # Función para calcular el coste de una solución
  funcionObjetivo <- function(solucion) {
    # Crear un vector de índices que representen los pares consecutivos de ciudades
    indices <- cbind(solucion, c(solucion[-1], solucion[1]))

    # Sumar las distancias
    return(sum(matrizDistancias[indices]))
  }

  # Generación de una solución inicial, usando un algoritmo voraz
  generarSolucionInicial <- function() {
    solucion <- c(1)
    ciudadActual <- 1
    visitadas <- logical(numCiudades)
    visitadas[ciudadActual] <- TRUE

    for( i in 2:numCiudades ){
      distancias <- matrizDistancias[ciudadActual, ]
      distancias[visitadas] <- Inf
      ciudadActual <- which.min(distancias)

      solucion[i] <- ciudadActual
      visitadas[ciudadActual] <- TRUE
    }

    return(solucion)
  }

  # Devolver el objeto core con las funciones
  list(
    numCiudades = numCiudades,
    funcionObjetivo = funcionObjetivo,
    generarSolucionInicial = generarSolucionInicial
  )
}
