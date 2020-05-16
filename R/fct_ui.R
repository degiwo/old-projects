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
ui_sidebar <- function(footer) {
  dashboardSidebar(
    # get_golem_version does not work during local build -> try
    try({print_version_in_footer()})
  )
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
