#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  df_timesheet <- reactiveVal(
    transform_timesheet_data(read_all_timesheet_files("/Users/dwon/Desktop/Timesheet"))
  )
  # List the first level callModules here
  callModule(mod_dashboard_server, "tab_dashboard", df_timesheet = df_timesheet)
}
