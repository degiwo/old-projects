#' dashboard UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom plotly plotlyOutput
mod_dashboard_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Dashboard"),
    plotlyOutput(ns("chart_project_bars"))
  )
}
    
#' dashboard Server Function
#'
#' @import dplyr ggplot2
#' @importFrom plotly renderPlotly ggplotly
#' @noRd 
mod_dashboard_server <- function(input, output, session, df_timesheet){
  ns <- session$ns
  
  output$chart_project_bars <- renderPlotly({
    df_project_durations <- df_timesheet() %>%
      group_by(month = format(startdate, "%Y-%m"), project_name) %>%
      summarise(sum_duration_h = round(sum(duration_h), 2)) %>%
      ungroup() %>%
      group_by(month) %>%
      mutate(prop_duration = round(100 * sum_duration_h / sum(sum_duration_h), 2))
    p <- ggplot(df_project_durations, aes(x = month, y = prop_duration, fill = project_name)) +
      geom_bar(stat = "identity") +
      labs(x = "Monat", y = "Anteil in %", fill = "Projekt")
    ggplotly(p)
  })
}
    
## To be copied in the UI
# mod_dashboard_ui("dashboard_ui_1")
    
## To be copied in the server
# callModule(mod_dashboard_server, "dashboard_ui_1")
 
