#' dashboard UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import shiny
#' @importFrom plotly plotlyOutput
mod_dashboard_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Übersicht"),
    plotlyOutput(ns("chart_project_bars")),
    plotlyOutput(ns("chart_project_lines"))
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
      get_converted_date("month") %>%
      get_sum_by_group(target = duration_h, project_name, new_startdate)
    p <- ggplot(df_project_durations,
                aes(x = new_startdate, y = sum_target, fill = reorder(project_name, -sum_target))) +
      geom_bar(position = "fill", stat = "identity") +
      labs(x = "Monat", y = "Anteil", fill = "Projekt")
    ggplotly(p)
  })
  
  output$chart_project_lines <- renderPlotly({
    df_project_durations <- df_timesheet() %>%
      filter(startdate >= Sys.Date() - 60) %>%
      get_converted_date("week") %>%
      get_sum_by_group(target = duration_h, project_name, new_startdate)
    df_all_project_startdate <- expand.grid(
      project_name = unique(df_project_durations$project_name),
      new_startdate = unique(df_project_durations$new_startdate)
    ) %>%
      left_join(df_project_durations, by = c("project_name", "new_startdate")) %>%
      mutate(sum_target = ifelse(is.na(sum_target), 0, sum_target))
    p <- ggplot(df_all_project_startdate,
                aes(x = new_startdate, y = sum_target, color = reorder(project_name, -sum_target))) +
      geom_line(group = 1) +
      labs(x = "KW", y = "Stunden", color = "Projekt")
    ggplotly(p)
  })
}
    
## To be copied in the UI
# mod_dashboard_ui("dashboard_ui_1")
    
## To be copied in the server
# callModule(mod_dashboard_server, "dashboard_ui_1")
 
