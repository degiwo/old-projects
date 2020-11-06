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
    h1("Dashboard")
  )
}
    
#' dashboard Server Function
#'
#' @import dplyr
#' @noRd 
mod_dashboard_server <- function(input, output, session, df_timesheet){
  ns <- session$ns
  
  observe({
    df_timesheet() %>%
      group_by(cost_center) %>%
      summarise(sum_duration = sum(duration)) %>%
      print()
  })
}
    
## To be copied in the UI
# mod_dashboard_ui("dashboard_ui_1")
    
## To be copied in the server
# callModule(mod_dashboard_server, "dashboard_ui_1")
 
