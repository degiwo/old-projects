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
    ),

    fluidRow(
      box(
        plotOutput(ns("plt_cumul_duration")),

        # box properties
        title = "geleistete Stunden", width = 12
      )
    )
  )
}

#' projectview Server Function
#'
#' @import shiny
#' @import shinyWidgets dplyr ggplot2
#' @noRd
mod_projectview_server <- function(input, output, session, rct_timesheet) {
  update_costcenter_dropdown(session, rct_timesheet)
  update_workpackage_dropdown(input, session, rct_timesheet)

  output$table_projectinformation <- DT::renderDT({
    df <- rct_timesheet()
    tbl <- filter_by_selection(input, df) %>%
      get_summarised_duration()
    names(tbl) <- c("Kostenstelle", "Arbeitspaket", "kumul. Stunden")

    return(tbl)
  })

  output$plt_cumul_duration <- renderPlot({
    df <- filter_by_selection(input, rct_timesheet())

    ggplot(df, aes(
      x = startdate,
      y = cumsum(duration),
      color = workpackage
    )) +
      geom_line() +
      labs(x = "Datum", y = "Stunden (kumuliert)", color = "Arbeitspaket")
  })
}
