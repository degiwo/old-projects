#' get target days for each month
#'
#' @noRd
#' @import dplyr
get_target_days <- function() {
  filepath <- "data/targets.csv"
  df <- read.csv2(filepath)
  return(df)
}

#' get vacation days for each employee
#'
#' @noRd
#' @import dplyr
get_vacation_days <- function() {
  filepath <- "data/vacation.csv"
  df <- read.csv2(filepath) %>%
    mutate(project_name = "Urlaub")
  return(df)
}
