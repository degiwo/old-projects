#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny magrittr
#' @noRd
app_server <- function( input, output, session ) {
  df_timesheet <- "/Users/dwon/Desktop/Timesheet" %>%
    read_all_timesheet_files() %>%
    join_project_names() %>%
    transform_timesheet_data() %>%
    reactiveVal()
  
  df_ba <- "/Users/dwon/Desktop/Timesheet/Projektzuordnungen_IST.txt" %>%
    read.delim(sep = ";") %>%
    filter(kostenstelle != "DATUM DER") %>%
    mutate(cost_center = kostenstelle) %>%
    join_project_names() %>%
    reactiveVal()
  # List the first level callModules here
  callModule(mod_dashboard_server, "tab_dashboard", df_timesheet = df_timesheet)
  callModule(mod_projects_server, "tab_projects", df_timesheet = df_timesheet)
  callModule(mod_business_analytics_server, "tab_business_analytics", df_ba = df_ba)
  callModule(mod_detail_server, "tab_detail", df_timesheet = df_timesheet)
}
