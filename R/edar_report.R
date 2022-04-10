#' Create edar report
#'
#' @description Generate the edar report for the given data.
#' @param data data.frame
#'
#' @return A summary table.
#' @export
#'
#' @examples
#' data(mtcars)
#' edar_report(mtcars)
edar_report <- function(data) {
  print(skim_data(data))

  for (col in names(data)) {
    if (is.numeric(data[, col])) {
      print(plot_histogram(data, col))
    }
  }
}
