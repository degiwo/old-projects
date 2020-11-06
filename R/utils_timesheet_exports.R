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
      read.csv2(stringsAsFactors = FALSE) %>%
      mutate(workpackage = coalesce(workpackage, "NA")) %>%
      mutate(cost_center = as.character(str_extract(files[i], "[^_]+")))
  }
  df <- do.call(rbind, list_df)
  return(df)
}


#' Join project names
#'
#' @import dplyr
#' @noRd
join_project_names <- function(input_df) {
  df_project_name <- data.frame(
    cost_center = c("60160417", "80160353", "80160282", "80000000", "80010000"),
    project_name = c("PLUTO Design", "BMW Motorrad", "IFCM", "BA Allgemein", "BA oL"),
    stringsAsFactors = FALSE
  )
  df <- input_df %>%
    left_join(df_project_name, by = "cost_center") %>%
    mutate(project_name = coalesce(project_name, cost_center))
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
    mutate(duration_h = as.numeric(as.difftime(as.character(duration), "%H:%M", units = "hours"))) %>%
    mutate(duration_d = duration_h / 8)
  return(df)
}
