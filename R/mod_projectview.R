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
                  choices = sort(unique(timesheet_raw$costcenter)),
                  options = list(`live-search` = TRUE)
      ),
      
      # dropdown for workpackage
      pickerInput(ns("sel_workpackage"),
                  label = "Arbeitspaket",
                  multiple = TRUE,
                  choices = sort(unique(timesheet_raw$workpackage)),
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
mod_projectview_server <- function(input, output, session) {
  # ns <- session$ns

  observe({
    new_choices <- timesheet_raw$workpackage[timesheet_raw$costcenter ==
      input$sel_costcenter]
    updatePickerInput(session,
      "sel_workpackage",
      choices = sort(unique(new_choices)),
      selected = unique(new_choices)
    )
  })
}
