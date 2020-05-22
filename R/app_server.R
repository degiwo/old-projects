#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # load data in reactive function to call it later in the modules/functions
  rct_timesheet <- reactive({
    df <- set_name_for_workpackages(testdata_timesheet)
    
    return(df)
  })

  # List the first level callModules here
  callModule(mod_projectview_server,
    "projectview_ui_1",
    rct_timesheet = rct_timesheet
  )
}
