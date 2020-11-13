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
    radioButtons(ns("sel_timegroup"), label = "Aufteilung", choices = NA),
    DTOutput(ns("tbl_prj_wp")),
    DTOutput(ns("tbl_wp_emp"))
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
  
  observe({
    choicenames <- c("Woche", "Monat", "Jahr", "Gesamt")
    choicevalues <- c("week", "month", "year", "all")
    updateRadioButtons(session, "sel_timegroup", selected = "month",
                       choiceNames = choicenames, choiceValues = choicevalues)
  })
  
  output$tbl_prj_wp <- renderDT({
    df_timesheet() %>%
      get_filtered_data(input_vars = input) %>%
      get_converted_date(format_var = input$sel_timegroup) %>%
      get_sum_by_group(target = duration_h, project_name, workpackage, new_startdate) %>%
      rename(Projekt = project_name, Arbeitspaket = workpackage) %>%
      spread(key = "new_startdate", value = "sum_target")
  })
  
  output$tbl_wp_emp <- renderDT({
    df_timesheet() %>%
      get_filtered_data(input_vars = input) %>%
      get_converted_date(format_var = input$sel_timegroup) %>%
      get_sum_by_group(target = duration_h, employee, new_startdate) %>%
      spread(key = "new_startdate", value = "sum_target")
  })
}

## To be copied in the UI
# mod_projects_ui("projects_ui_1")
    
## To be copied in the server
# callModule(mod_projects_server, "projects_ui_1")
 
