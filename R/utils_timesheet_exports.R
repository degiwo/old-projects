#' Read timesheet exports
#'
#' @import dplyr
#' @importFrom stringr str_extract
#' @noRd
read_all_timesheet_files <- function(path) {
  files <- list.files(path, pattern = ".csv")
  list_df <- list()
  for(i in seq(files)) {
    list_df[[i]] <- file.path(path, files[i]) %>%
      read.csv2() %>%
      mutate(cost_center = str_extract(files[i], "[^_]+"))
  }
  df <- do.call(rbind, list_df)
  return(df)
}


#' Convert into correct data types
#'
#' @import dplyr
#' @noRd
transform_timesheet_data <- function(input_df) {
  df <- input_df %>%
    distinct() %>%
    mutate(startdate = as.Date(startdate, "%d.%m.%Y %H:%M")) %>%
    mutate(duration = as.difftime(as.character(duration), "%H:%M", units = "hours"))
  return(df)
}
