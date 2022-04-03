#' Plot histogram
#'
#' @param data data.frame
#' @param column string
#'
#' @return plots
#'
#' @import ggplot2
#' @importFrom grDevices nclass.Sturges
plot_histogram <- function(data, column) {
  # Calculating the Sturges bins
  breaks <- pretty(range(data[, column]),
    n = nclass.Sturges(data[, column]),
    min.n = 1
  )

  ggplot(data, aes_string(x = column)) +
    geom_histogram(aes(y = ..density..), breaks = breaks) +
    geom_density() +
    labs(title = paste0(
      "Histogram of ", column,
      " (n: ", sum(!is.na(data[column])), ")"
    ))
}
