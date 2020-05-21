#' projectview UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import shiny
#' @import shinydashboard
#' @import shinyWidgets
mod_projectview_ui <- function(id) {
  ns <- NS(id)

  tagList(
    # UI header
    h2("Projektansicht"),

    # UI body
    box(
      create_costcenter_dropdown(ns),
      create_workpackage_dropdown(ns),

      # box properties
      title = "Projektauswahl", width = 6, collapsible = TRUE
    )
  )
}

#' projectview Server Function
#'
#' @import shiny
#' @import shinyWidgets
#' @noRd
mod_projectview_server <- function(input, output, session, data) {
  update_costcenter_dropdown(session, data)
  update_workpackage_dropdown(input, session, data)
}
