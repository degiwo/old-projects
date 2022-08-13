#' Application UI header
#'
#' @importFrom shinydashboard dashboardHeader
#' @noRd
ui_header <- function() {
  dashboardHeader(title = "OWControlling")
}

#' Application UI sidebar
#'
#' @importFrom shiny icon
#' @importFrom shinydashboard dashboardSidebar sidebarMenu menuItem
#' @noRd
ui_sidebar <- function(footer) {
  dashboardSidebar(
    sidebarMenu(
      menuItem("Projektansicht",
        tabName = "projectview_ui_1",
        icon = icon("chart-line")
      )
    ),

    # get_golem_version does not work during local build -> try
    try({
      print_version_in_footer()
    })
  )
}

#' Application UI body
#'
#' @import shiny
#' @importFrom shinydashboard dashboardBody tabItems tabItem
#' @noRd
ui_body <- function() {
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "projectview_ui_1",
        mod_projectview_ui("projectview_ui_1")
      )
    )
  )
}
