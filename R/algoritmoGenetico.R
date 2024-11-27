#' Implementación de un Algoritmo Genético para el problema TSP
#'
#' @param matrizDistancias Matriz de distancias
#' @param tamPoblacion Tamaño de la población.
#' @param numGeneraciones Número de generaciones a realizar.
#' @param porcentajeElistismo Porcentaje de la población que se conserva en cada generación.
#' @return Lista con los resultados del algoritmo genético.
algoritmo_genetico <- function(matrizDistancias, tamPoblacion, numGeneraciones, porcentajeElistismo) {

  core <- crear_core_tsp(matrizDistancias)

  # Tiempo de inicio
  inicio <- Sys.time()

  poblacion <- generarPoblacionInicial(tamPoblacion, core)
  elitismo <- ceiling(tamPoblacion * porcentajeElistismo)
  listaCostes <- c()
  listaDiversidad <- c()
  iteracionesSinCambios <- 0
  costeAnterior <- core$funcionObjetivo(poblacion[[which.max(sapply(poblacion, function(sol) calcularAptitud(sol, core)))]])

  for (gen in seq_len(numGeneraciones)) {
    # Selección de la nueva población
    nuevaPoblacion <- poblacion[order(sapply(poblacion, function(sol) calcularAptitud(sol, core)), decreasing = TRUE)][1:elitismo]

    if (core$funcionObjetivo(nuevaPoblacion[[1]]) == costeAnterior) {
      iteracionesSinCambios <- iteracionesSinCambios + 1
      if (iteracionesSinCambios == 10) break
    } else {
      iteracionesSinCambios <- 0
      costeAnterior <- core$funcionObjetivo(nuevaPoblacion[[1]])
    }

    listaCostes <- c(listaCostes, core$funcionObjetivo(nuevaPoblacion[[1]]))
    listaDiversidad <- c(listaDiversidad, length(unique(sapply(poblacion, paste, collapse = ""))))
    iterar <- 1
    while (length(nuevaPoblacion) < tamPoblacion) {
      padres <- seleccion(poblacion, core)

      hijos <- crucePMX(padres[[1]], padres[[2]], core)

      nuevaPoblacion <- c(nuevaPoblacion, list(aplicarMutacion(hijos[[1]]), aplicarMutacion(hijos[[2]])))

    }

    poblacion <- nuevaPoblacion[1:tamPoblacion]
  }

  mejorSolucion <- poblacion[[which.max(sapply(poblacion, function(sol) calcularAptitud(sol, core)))]]
  mejorCoste <- core$funcionObjetivo(mejorSolucion)

  # Tiempo final
  fin <- Sys.time()

  return(list(
    mejorSolucion = mejorSolucion,
    mejorCoste = mejorCoste,
    tiempoCPU = difftime(fin, inicio, units = "secs"),
    listaCostes = listaCostes,
    listaDiversidad = listaDiversidad
  ))
}

# Calcular la aptitud (inversa del coste)
calcularAptitud <- function(solucion, core) {
  distanciaTotal <- core$funcionObjetivo(solucion)
  return(1 / distanciaTotal)
}

# Generar la población inicial
generarPoblacionInicial <- function(tamPoblacion, core) {
  poblacion <- list()
  for (i in seq_len(tamPoblacion)) {
    solucion <- sample(seq_len(core$numCiudades))
    poblacion[[i]] <- solucion
  }
  return(poblacion)
}

# Selección por torneo
seleccion <- function(poblacion, core) {
  tamTorneo <- 3
  torneo <- sample(poblacion, tamTorneo, replace = FALSE)
  indices <- order(sapply(torneo, function(sol) calcularAptitud(sol, core)), decreasing = TRUE)[1:2]
  padres <- torneo[indices]

  return(list(padres[[1]], padres[[2]]))
}

# Cruce PMX (Partial-Mapped Crossover)
crucePMX <- function(padre1, padre2, core) {
  # Generar puntos de cruce
  puntos <- sort(sample(seq_len(core$numCiudades), 2))
  punto1 <- puntos[1]
  punto2 <- puntos[2]

  hijo1 <- padre1
  hijo2 <- padre2

  mapeo <- setNames(padre2[punto1:punto2], padre1[punto1:punto2])

  for (i in names(mapeo)) {
    i <- as.numeric(i)

    if (i %in% hijo1) {
      indice1 <- which(hijo1 == i)
      valor_map <- mapeo[[as.character(i)]]

      if (valor_map %in% hijo1) {
        indice2 <- which(hijo1 == valor_map)
        hijo1[indice2] <- i
      }
      hijo1[indice1] <- valor_map
    }

    if (i %in% hijo2) {
      indice1 <- which(hijo2 == i)
      valor_map <- mapeo[[as.character(i)]]

      if (valor_map %in% hijo2) {
        indice2 <- which(hijo2 == valor_map)
        hijo2[indice2] <- i
      }
      hijo2[indice1] <- valor_map
    }
  }


  return(list(hijo1 = hijo1, hijo2 = hijo2))
}

# Mutación por intercambio
aplicarMutacion <- function(gen) {
  if (runif(1) < 0.5) {
    indices <- sample(seq_along(gen), 2)
    tmp <- gen[indices[1]]
    gen[indices[1]] <- gen[indices[2]]
    gen[indices[2]] <- tmp
  }
  return(gen)
}
