#' projects UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import shiny shinyWidgets
#' @importFrom DT DTOutput
mod_projects_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Projekte"),
    pickerInput_(ns("sel_project"), label = "Projekt"),
    pickerInput_(ns("sel_workpackage"), label = "Arbeitspaket", multiple = TRUE),
    DTOutput(ns("tbl_prj_wp"))
  )
}
    
#' projects Server Function
#'
#' @noRd
#' @import shiny shinyWidgets dplyr
#' @importFrom DT renderDT
mod_projects_server <- function(input, output, session, df_timesheet){
  ns <- session$ns
  
  observe({
    choices <- unique(df_timesheet()$project_name)
    updatePickerInput(session, "sel_project", choices = choices)
  })
  
  observe({
    choices <- df_timesheet()$workpackage[df_timesheet()$project_name %in% input$sel_project]
    choices <- sort(unique(choices))
    updatePickerInput(session, "sel_workpackage", choices = choices, selected = choices)
  })
  
  output$tbl_prj_wp <- renderDT({
    df_timesheet() %>%
      filter(project_name %in% input$sel_project) %>%
      filter(workpackage %in% input$sel_workpackage) %>%
      group_by(project_name, workpackage) %>%
      summarise(sum_duration_d = round(sum(duration_d), 2)) %>%
      rename(Projekt = project_name, Arbeitspaket = workpackage, `PT Gesamt` = sum_duration_d)
  })
}
    
## To be copied in the UI
# mod_projects_ui("projects_ui_1")
    
## To be copied in the server
# callModule(mod_projects_server, "projects_ui_1")
 
