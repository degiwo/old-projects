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
    fluidRow(
      box(
        create_costcenter_dropdown(ns),
        create_workpackage_dropdown(ns),

        # box properties
        title = "Projektauswahl", width = 6, collapsible = TRUE
      )
    ),

    fluidRow(
      box(
        DT::DTOutput(ns("table_projectinformation")),

        # box properties
        title = "Projektinformationen", width = 12, collapsible = TRUE
      )
    )
  )
}

#' projectview Server Function
#'
#' @import shiny
#' @import shinyWidgets
#' @noRd
mod_projectview_server <- function(input, output, session, rct_timesheet) {
  update_costcenter_dropdown(session, rct_timesheet)
  update_workpackage_dropdown(input, session, rct_timesheet)

  output$table_projectinformation <- DT::renderDT({
    tbl <- get_summarised_duration(rct_timesheet())
    names(tbl) <- c("Arbeitspaket", "kumul. Stunden")
    
    return(tbl)
  })
}
