#' Dropdown for costcenter
#'
#' @noRd
create_costcenter_dropdown <- function(ns) {
  pickerInput(ns("sel_costcenter"),
    label = "Projekt",
    choices = NULL,
    options = list(`live-search` = TRUE)
  )
}

#' Dropdown for workpackage
#'
#' @noRd
create_workpackage_dropdown <- function(ns) {
  pickerInput(ns("sel_workpackage"),
    label = "Arbeitspaket",
    choices = NULL,
    multiple = TRUE,
    options = list(`actions-box` = TRUE, `live-search` = TRUE)
  )
}
