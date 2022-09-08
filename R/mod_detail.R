#' detail UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import shiny
#' @importFrom DT DTOutput
mod_detail_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Detailsicht"),
    pickerInput_(ns("sel_project"), label = "Projekt"),
    DTOutput(ns("tbl_prj"))
  )
}
    
#' detail Server Function
#'
#' @noRd 
#' @import shiny shinyWidgets dplyr
#' @importFrom DT renderDT datatable
mod_detail_server <- function(input, output, session, df_timesheet){
  ns <- session$ns
  
  observe({
    choices <- unique(df_timesheet()$project_name)
    updatePickerInput(session, "sel_project", choices = choices, selected = choices[1])
  })
  
  output$tbl_prj <- renderDT({
    df_timesheet() %>%
      filter(project_name == input$sel_project) %>%
      datatable(filter = "top")
  })
}
    
## To be copied in the UI
# mod_detail_ui("detail_ui_1")
    
## To be copied in the server
# callModule(mod_detail_server, "detail_ui_1")
