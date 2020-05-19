#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # load data in reactive functions to call it later in the modules/functions
  df_timesheet_raw <- reactive({
    return(timesheet_raw)
  })

  # List the first level callModules here
  callModule(mod_projectview_server,
    "projectview_ui_1",
    data = df_timesheet_raw
  )
}
