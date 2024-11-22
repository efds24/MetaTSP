#' Implementación de la metaheurística de colonia de hormigas para el TSP
#'
#' @param matrizDistancias Matriz de distancias.
#' @param numHormigas Número de hormigas a utilizar.
#' @param maxIteraciones Número máximo de iteraciones.
#' @param tasaEvaporacion Tasa de evaporación de las feromonas.
#' @param alfa Parámetro alfa (importancia de las feromonas).
#' @param beta Parámetro beta (importancia de las distancias).
#' @return Lista con la mejor solución encontrada, su coste y métricas del proceso.
optimizacion_colonia_hormigas <- function(matrizDistancias, numHormigas, maxIteraciones, tasaEvaporacion, alfa, beta) {
  core <- crear_core_tsp(matrizDistancias)

  inicio <- Sys.time()

  # Inicializar matriz de feromonas
  matrizFeromonas <- matrix(1, nrow = core$numCiudades, ncol = core$numCiudades)

  mejorSolucion <- NULL
  mejorCoste <- Inf
  listaCosteMedio <- numeric(maxIteraciones)  # Preasignamos para almacenar el coste medio

  for (iter in seq_len(maxIteraciones)) {
    soluciones <- vector("list", numHormigas)
    costes <- numeric(numHormigas)

    # Construir soluciones para todas las hormigas
    for (hormiga in seq_len(numHormigas)) {
      solucion <- construirSolucion(core, matrizFeromonas, matrizDistancias, alfa, beta)
      coste <- core$funcionObjetivo(solucion)

      soluciones[[hormiga]] <- solucion
      costes[hormiga] <- coste

      # Actualizar la mejor solución
      if (coste < mejorCoste) {
        mejorCoste <- coste
        mejorSolucion <- solucion
      }
    }

    # Actualizar la matriz de feromonas de forma vectorizada
    matrizFeromonas <- actualizarMatrizFeromonas(soluciones, costes, matrizFeromonas, tasaEvaporacion)

    # Guardar el coste promedio de esta iteración
    listaCosteMedio[iter] <- mean(costes)
  }

  fin <- Sys.time()

  return(list(
    mejorSolucion = mejorSolucion,
    mejorCoste = mejorCoste,
    listaCosteMedio = listaCosteMedio,
    matrizFeromonas = matrizFeromonas,
    tiempoCPU = difftime(fin, inicio, units = "secs")
  ))
}

# Construir una solución
construirSolucion <- function(core, matrizFeromonas, matrizDistancias, alfa, beta) {
  solucion <- numeric(core$numCiudades)
  visitadas <- logical(core$numCiudades)
  solucion[1] <- sample(seq_len(core$numCiudades), 1)  # Ciudad inicial aleatoria
  visitadas[solucion[1]] <- TRUE

  for (i in 2:core$numCiudades) {
    ciudadActual <- solucion[i - 1]
    solucion[i] <- seleccionarSiguienteCiudad(core, ciudadActual, visitadas, alfa, beta, matrizFeromonas, matrizDistancias)
    visitadas[solucion[i]] <- TRUE
  }

  return(solucion)
}

# Seleccionar la siguiente ciudad
seleccionarSiguienteCiudad <- function(core, ciudadActual, visitadas, alfa, beta, matrizFeromonas, matrizDistancias) {

  # Calcular probabilidades para todas las ciudades en una línea
  probabilidades <- ifelse(
    visitadas,
    0,  # Asignar 0 si la ciudad ya fue visitada
    (matrizFeromonas[ciudadActual, ]^alfa) * ((1 / matrizDistancias[ciudadActual, ])^beta)
  )

  # Normalizar las probabilidades
  probabilidades <- probabilidades / sum(probabilidades)

  # Seleccionar una ciudad no visitada según las probabilidades
  return(sample(seq_len(core$numCiudades), 1, prob = probabilidades))

}

# Actualizar la matriz de feromonas
actualizarMatrizFeromonas <- function(soluciones, costes, matrizFeromonas, tasaEvaporacion) {
  # Evaporación de las feromonas de todas las rutas
  matrizFeromonas <- matrizFeromonas * (1 - tasaEvaporacion)

  # Actualización de feromonas basadas en las soluciones recorridas
  for (i in seq_along(soluciones)) {
    solucion <- soluciones[[i]]
    coste <- costes[i]
    for (j in seq_len(length(solucion) - 1)) {
      ciudad1 <- solucion[j]
      ciudad2 <- solucion[j + 1]
      matrizFeromonas[ciudad1, ciudad2] <- matrizFeromonas[ciudad1, ciudad2] + (1 / coste)
    }
  }

  return(matrizFeromonas)
}
