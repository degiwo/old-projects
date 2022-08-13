#' Set a dummy name for entries without a workpackage
#'
#' @noRd
set_name_for_workpackages <- function(data_timesheet) {
  data_timesheet$workpackage[is.na(data_timesheet$workpackage)] <- "OHNE AP"
  
  return(data_timesheet)
}
