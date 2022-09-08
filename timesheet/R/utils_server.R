#' filter the data by inputs
#'
#' @noRd
#' @import dplyr
get_filtered_data <- function(df_input, input_vars) {
  .start <- req(input_vars$sel_daterange[1])
  .end <- req(input_vars$sel_daterange[2])
  
  df_input %>%
    filter(startdate >= .start & startdate <= .end) %>%
    filter(project_name %in% input_vars$sel_project) %>%
    filter(workpackage %in% input_vars$sel_workpackage)
}

#' convert startdate column in new format
#'
#' @noRd
#' @import dplyr
get_converted_date <- function(df_input, format_var) {
  if(format_var == "year") {
    df_output <- df_input %>%
      mutate(new_startdate = format(startdate, "%Y"))
  }
  if(format_var == "month") {
    df_output <- df_input %>%
      mutate(new_startdate = format(startdate, "%Y-%m"))
  }
  if(format_var == "week") {
    df_output <- df_input %>%
      mutate(new_startdate = format(startdate, "%Y-%V"))
  }
  if(format_var == "all") {
    df_output <- df_input %>%
      mutate(new_startdate = "Gesamt")
  }
  df_output
}

#' calculate sum of target for each ...
#'
#' @noRd
#' @import dplyr
get_sum_by_group <- function(df_input, target, ...) {
  target_var <- enquo(target)
  group_var <- quos(...)
  df_input %>%
    group_by(!!! group_var) %>%
    summarise(sum_target = round(sum(!! target_var), 2)) %>%
    ungroup()
}

#' calculate cumsum of target for each ... arrange by sort
#'
#' @noRd
#' @import dplyr
get_cumulated_duration_by_group <- function(df_input, target, sort, ...) {
  target_var <- enquo(target)
  sort_var <- enquo(sort)
  group_var <- quos(...)
  df_input %>%
    arrange(!! sort_var, !!! group_var) %>%
    group_by(!!! group_var) %>%
    mutate(cumsum_target = round(cumsum(!! target_var), 2)) %>%
    ungroup()
}
