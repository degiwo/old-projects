#' Application UI header
#'
#' @importFrom shinydashboard dashboardHeader
#' @noRd
ui_header <- function() {
  dashboardHeader(title = "OWControlling")
}

#' Application UI sidebar
#'
#' @importFrom shinydashboard dashboardSidebar
#' @noRd
ui_sidebar <- function() {
  dashboardSidebar()
}

#' Application UI body
#'
#' @import shiny
#' @importFrom shinydashboard dashboardBody
#' @noRd
ui_body <- function() {
  dashboardBody(
    p("Dummy text")
  )
}
