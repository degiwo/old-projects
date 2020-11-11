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
    pickerInput_(ns("sel_workpackage"), label = "Arbeitspaket",
                 multiple = TRUE),
    airDatepickerInput(ns("sel_daterange"), label = "Zeitraum",
                       range = TRUE, dateFormat = "dd.mm.yyyy", update_on = "close"),
    DTOutput(ns("tbl_prj_wp"))
  )
}
    
#' projects Server Function
#'
#' @noRd
#' @import shiny shinyWidgets dplyr
#' @importFrom DT renderDT
#' @importFrom tidyr spread
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
  
  observe({
    updateAirDateInput(session, "sel_daterange", value = c(min(df_timesheet()$startdate), Sys.Date()))
  })
  
  output$tbl_prj_wp <- renderDT({
    .start <- req(input$sel_daterange[1])
    .end <- req(input$sel_daterange[2])
    
    df_timesheet() %>%
      filter(startdate >= .start & startdate <= .end) %>%
      filter(project_name %in% input$sel_project) %>%
      filter(workpackage %in% input$sel_workpackage) %>%
      get_sum_per_month() %>%
      rename(Projekt = project_name, Arbeitspaket = workpackage) %>%
      spread(key = "month", value = "sum_duration")
  })
}

#' calculate sum of duration_d for each project_name, workpackage, month
#'
#' @noRd
#' @import dplyr
get_sum_per_month <- function(df_input) {
  df_input %>%
    mutate(month = format(startdate, "%Y-%m")) %>%
    group_by(project_name, workpackage, month) %>%
    summarise(sum_duration = round(sum(duration_h), 2)) %>%
    ungroup()
}
    
## To be copied in the UI
# mod_projects_ui("projects_ui_1")
    
## To be copied in the server
# callModule(mod_projects_server, "projects_ui_1")
 
