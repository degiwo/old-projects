#' get target days for each month
#'
#' @noRd
#' @import dplyr
get_target_days <- function() {
  filepath <- "data/targets.csv"
  return(read.csv2(filepath))
}
