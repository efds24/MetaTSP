#' Templado Simulado para resolver el problema del viajante de comercio (TSP)
#'
#' Este algoritmo utiliza el metodo de templado simualdo para encontrar una solución aproximada al TSP.
#'
#' @param matrizDistancias Matriz de distancias
#' @param temperaturaInicial Temperatura inicial del templado simulado.
#' @param tasaEnfriamiento La tasa de enfriamiento de la temperatura (valor entre 0 y 1).
#' @param temperaturaParada Temperatura mínima para detener el algoritmo.
#' @param maxIteracionesSinCambios Máximo número de iteraciones sin cambios permitidas.
#' @param maxIteraciones Número máximo de iteraciones por temperatura.
#' @return Una lista con la mejor solución, su coste, y datos del proceso (temperaturas, costes, probabilidad de aceptacion).
templado_simulado <- function(matrizDistancias, temperaturaInicial, tasaEnfriamiento, temperaturaParada, maxIteracionesSinCambios, maxIteraciones) {

  core <- crear_core_tsp(matrizDistancias)

  # Inicialización
  inicio <- Sys.time()
  solucion <- core$generarSolucionInicial()
  mejorSolucion <- solucion
  mejorCoste <- core$funcionObjetivo(solucion)

  iteracionesSinCambios <- 0
  temperatura <- temperaturaInicial

  # Prealocar vectores
  listaTemperaturas <- c(temperaturaInicial)
  listaCostes <- c(mejorCoste)
  listaProbAceptacion <- c()

  coste <- mejorCoste
  costeAnterior <- mejorCoste
  iter <- 1

  # Algoritmo de templado simulado
  while (temperatura > temperaturaParada) {
    for (iter_interior in seq_len(maxIteraciones)) {
      # Elegir dos ciudades aleatoriamente
      indices <- sample(seq_along(solucion), 2)
      i <- indices[1]
      j <- indices[2]

      # Crear una solución vecina intercambiando las ciudades i y j
      solucionTmp <- solucion
      solucionTmp[c(i, j)] <- solucionTmp[c(j, i)]

      # Calcular el coste de la nueva solución
      costeTmp <- core$funcionObjetivo(solucionTmp)
      delta <- costeTmp - coste
      probAceptacion <- exp(-delta / temperatura)

      # Decidir si se acepta la nueva solución
      if (delta < 0 || runif(1) < probAceptacion) {
        solucion <- solucionTmp
        coste <- costeTmp
      }

      # Guardar métricas
      listaProbAceptacion <- c(listaProbAceptacion, probAceptacion)
      listaCostes <- c(listaCostes, coste)
      iter <- iter + 1
    }

    # Enfriar la temperatura
    temperatura <- temperatura * (1 - tasaEnfriamiento)
    listaTemperaturas <- c(listaTemperaturas, temperatura)

    # Control de iteraciones sin cambios
    if (coste == costeAnterior) {
      iteracionesSinCambios <- iteracionesSinCambios + 1
      if (iteracionesSinCambios >= maxIteracionesSinCambios) break
    } else {
      iteracionesSinCambios <- 0
      costeAnterior <- coste
    }
  }

  # Fin del tiempo de ejecución
  fin <- Sys.time()

  # Devolver resultados
  list(
    mejorSolucion = solucion,
    mejorCoste = coste,
    tiempoCPU = difftime(fin, inicio, units = "secs"),
    listaTemperaturas = listaTemperaturas,
    listaCostes = listaCostes,
    listaProbAceptacion = listaProbAceptacion
  )
}

