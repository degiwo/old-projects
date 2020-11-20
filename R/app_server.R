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
  # List the first level callModules here
  callModule(mod_dashboard_server, "tab_dashboard", df_timesheet = df_timesheet)
  callModule(mod_projects_server, "tab_projects", df_timesheet = df_timesheet)
  callModule(mod_detail_server, "tab_detail", df_timesheet = df_timesheet)
}
