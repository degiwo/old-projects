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
  skim_data(data)

  for (col in names(data)) {
    print(plot_histogram(data, col))
  }
}
