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
      # dropdown for costcenter
      pickerInput(ns("sel_costcenter"),
        label = "Projekt",
        choices = NULL,
        options = list(`live-search` = TRUE)
      ),

      # dropdown for workpackage
      pickerInput(ns("sel_workpackage"),
        label = "Arbeitspaket",
        choices = NULL,
        multiple = TRUE,
        options = list(`actions-box` = TRUE, `live-search` = TRUE)
      ),

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
  observe({
    choices <- unique(data()$costcenter)
    updatePickerInput(session,
      "sel_costcenter",
      choices = sort(choices)
    )
  })

  observe({
    new_choices <- data()$workpackage[data()$costcenter == input$sel_costcenter]
    updatePickerInput(session,
      "sel_workpackage",
      choices = sort(unique(new_choices)),
      selected = unique(new_choices)
    )
  })
}
