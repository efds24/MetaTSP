#' Búsqueda Tabú para resolver el problema del viajante de comercio (TSP)
#'
#' Implementa la búsqueda tabú, basada en la matriz de distancias.
#'
#' @param matrizDistancias matriz de distancias
#' @param maxIteraciones Número máximo de iteraciones.
#' @param permanenciaListaTabu Número de iteraciones que un movimiento permanece en la lista tabú.
#' @param maxIterSinMejora Número máximo de iteraciones sin mejora.
#' @return Una lista con la mejor solución encontrada, su coste, el tiempo que tardo y la última lista tabú.
busqueda_tabu <- function(matrizDistancias, maxIteraciones, permanenciaListaTabu, maxIterSinMejora) {

  core <- crear_core_tsp(matrizDistancias = matrizDistancias)

  # Tiempo de inicio
  inicio <- Sys.time()

  # Inicialización
  listaTabu <- list()
  solucion <- core$generarSolucionInicial()
  coste <- core$funcionObjetivo(solucion)
  mejorSolucion <- solucion
  mejorCoste <- coste
  iteracionesSinMejora <- 0

  # Iteraciones de búsqueda tabú
  for (iter in seq_len(maxIteraciones)) {
    # Generar vecindario
    vecindario <- generar_mejor_vecindario(solucion, mejorCoste, permanenciaListaTabu, core, listaTabu)
    coste <- vecindario$mejorCosteLocal
    solucion <- vecindario$mejorSolucionLocal
    listaTabu <- vecindario$listaTabu

    # Actualizar mejor solución global
    if (coste < mejorCoste) {
      iteracionesSinMejora <- 0
      mejorCoste <- coste
      mejorSolucion <- solucion
    } else {
      iteracionesSinMejora <- iteracionesSinMejora + 1
      if (iteracionesSinMejora == maxIterSinMejora) break
    }

    # Reducir tiempo de permanencia en lista tabú
    if (length(listaTabu) > 0) {
      listaTabu <- lapply(listaTabu, function(x) max(x - 1, 0))
    }
  }

  # Tiempo final
  fin <- Sys.time()

  # Devolver resultados
  list(
    mejorSolucion = mejorSolucion,
    mejorCoste = mejorCoste,
    tiempoCPU = difftime(fin, inicio, units = "secs"),
    listaTabu = listaTabu
  )
}

  # Función interna para generar el mejor vecindario
  generar_mejor_vecindario <- function(solucion, mejorCosteGlobal, permanenciaListaTabu, core, listaTabu) {
    # Generar todas las combinaciones posibles de pares (i, j) donde i < j
    indices <- combn(seq_along(solucion), 2)
    i <- indices[1, ]
    j <- indices[2, ]

    # Crear todas las soluciones posibles intercambiando i y j
    solucionesAux <- t(apply(indices, 2, function(idx) {
      solucionAux <- solucion
      solucionAux[idx] <- solucionAux[rev(idx)]
      solucionAux
    }))

    # Calcular costos de todas las soluciones
    costos <- apply(solucionesAux, 1, core$funcionObjetivo)

    # Comprobar si el movimiento es tabú
    movimientos <- paste(solucion[i], solucion[j], sep = "_")
    movimientosEnTabu <- movimientos %in% names(listaTabu)
    movimientosTabuActivos <- sapply(movimientos, function(mov) {
      if (mov %in% names(listaTabu) && is.numeric(listaTabu[[mov]])) {
        listaTabu[[mov]] > 0
      } else {
        FALSE
      }
    })

    tabu <- movimientosEnTabu & movimientosTabuActivos

    # Filtrar movimientos no tabú o aquellos que mejoran el coste global
    validos <- !tabu | (tabu & costos < mejorCosteGlobal)

    # Seleccionar el mejor movimiento
    if (any(validos)) {
      mejorIdx <- which.min(costos[validos])
      mejorCosteLocal <- costos[validos][mejorIdx]
      mejorSolucionLocal <- solucionesAux[validos, , drop = FALSE][mejorIdx, ]
      mejorMovimiento <- movimientos[validos][mejorIdx]

      # Actualizar lista tabú
      listaTabu[[mejorMovimiento]] <- permanenciaListaTabu
    } else {
      mejorCosteLocal <- Inf
      mejorSolucionLocal <- solucion
    }

    list(
      mejorCosteLocal = mejorCosteLocal,
      mejorSolucionLocal = mejorSolucionLocal,
      listaTabu = listaTabu
    )
  }

