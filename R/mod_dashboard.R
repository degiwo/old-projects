#' dashboard UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_dashboard_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Dashboard"),
    plotOutput(ns("chart_project_bars"))
  )
}
    
#' dashboard Server Function
#'
#' @import dplyr ggplot2
#' @noRd 
mod_dashboard_server <- function(input, output, session, df_timesheet){
  ns <- session$ns
  
  output$chart_project_bars <- renderPlot({
    df_project_durations <- df_timesheet() %>%
      group_by(Projekt = project_name) %>%
      summarise(PT = round(sum(duration_d), 2))
    p <- ggplot(df_project_durations, aes(x = reorder(Projekt, PT),
                                          y = PT,
                                          fill = Projekt)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(x = "Projekt", y = "Personentage gesamt")
    print(p)
  })
}
    
## To be copied in the UI
# mod_dashboard_ui("dashboard_ui_1")
    
## To be copied in the server
# callModule(mod_dashboard_server, "dashboard_ui_1")
 
