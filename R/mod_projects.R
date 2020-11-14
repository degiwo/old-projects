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
#' @importFrom plotly plotlyOutput
mod_projects_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Projekte"),
    pickerInput_(ns("sel_project"), label = "Projekt",
                 multiple = TRUE),
    pickerInput_(ns("sel_workpackage"), label = "Arbeitspaket",
                 multiple = TRUE),
    airDatepickerInput(ns("sel_daterange"), label = "Zeitraum",
                       range = TRUE, dateFormat = "dd.mm.yyyy", update_on = "close"),
    radioButtons(ns("sel_timegroup"), label = "Aufteilung", choices = NA),
    DTOutput(ns("tbl_prj_wp")),
    DTOutput(ns("tbl_prj_wp_detail")),
    plotlyOutput(ns("plt_prj_wp_line")),
    plotlyOutput(ns("plt_prj_wp_bar")),
    DTOutput(ns("tbl_wp_emp")),
    DTOutput(ns("tbl_wp_emp_detail"))
  )
}
    
#' projects Server Function
#'
#' @noRd
#' @import shiny shinyWidgets dplyr ggplot2
#' @importFrom DT renderDT
#' @importFrom tidyr spread
#' @importFrom plotly renderPlotly ggplotly
mod_projects_server <- function(input, output, session, df_timesheet){
  ns <- session$ns
  
  observe({
    choices <- unique(df_timesheet()$project_name)
    updatePickerInput(session, "sel_project", choices = choices, selected = choices[1])
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
  
  tbl_prj_wp_fct <- reactive({
    df_timesheet() %>%
      get_filtered_data(input_vars = input) %>%
      get_converted_date(format_var = input$sel_timegroup) %>%
      get_sum_by_group(target = duration_h, project_name, workpackage, new_startdate) %>%
      spread(key = "new_startdate", value = "sum_target")
  })
  
  selected_wp <- reactive({
    tbl_prj_wp_fct()$workpackage[input$tbl_prj_wp_rows_selected]
  })
  
  output$tbl_prj_wp <- renderDT({
    tbl_prj_wp_fct() %>%
      rename(Projekt = project_name, Arbeitspaket = workpackage)
  })
  
  output$tbl_wp_emp <- renderDT({
    df_timesheet() %>%
      get_filtered_data(input_vars = input) %>%
      get_converted_date(format_var = input$sel_timegroup) %>%
      get_sum_by_group(target = duration_h, employee, new_startdate) %>%
      spread(key = "new_startdate", value = "sum_target") %>%
      rename(Mitarbeiter = employee)
  })
  
  output$tbl_prj_wp_detail <- renderDT({
    df_timesheet() %>%
      mutate(new_workpackage = ifelse(workpackage %in% selected_wp(), 1, 0)) %>%
      get_filtered_data(input_vars = input) %>%
      get_converted_date(format_var = input$sel_timegroup) %>%
      get_sum_by_group(target = duration_h, new_workpackage, new_startdate) %>%
      spread(key = "new_startdate", value = "sum_target") %>%
      mutate(new_workpackage = ifelse(new_workpackage == 1, "ausgewählt", "nicht ausgewählt")) %>%
      rename(Arbeitspaket = new_workpackage)
  })
  
  output$tbl_wp_emp_detail <- renderDT({
    df_timesheet() %>%
      mutate(new_workpackage = ifelse(workpackage %in% selected_wp(), 1, 0)) %>%
      get_filtered_data(input_vars = input) %>%
      get_converted_date(format_var = input$sel_timegroup) %>%
      get_sum_by_group(target = duration_h, employee, new_workpackage, new_startdate) %>%
      spread(key = "new_startdate", value = "sum_target") %>%
      mutate(new_workpackage = ifelse(new_workpackage == 1, "ausgewählt", "nicht ausgewählt")) %>%
      rename(Mitarbeiter = employee, Arbeitspaket = new_workpackage)
  })
  
  output$plt_prj_wp_line <- renderPlotly({
    df <- df_timesheet() %>%
      mutate(new_workpackage = ifelse(workpackage %in% selected_wp(), 1, 0)) %>%
      get_filtered_data(input_vars = input) %>%
      get_converted_date(format_var = input$sel_timegroup) %>%
      get_sum_by_group(target = duration_h, new_workpackage, new_startdate) %>%
      mutate(new_workpackage = ifelse(new_workpackage == 1, "ausgewählt", "nicht ausgewählt"))
    p <- ggplot(df, aes(x = new_startdate, y = sum_target, color = new_workpackage)) +
      geom_line(group = 1) +
      labs(x = "", y = "Stunden gesamt", color = "Arbeitspaket")
    ggplotly(p)
  })
  
  output$plt_prj_wp_bar <- renderPlotly({
    df <- df_timesheet() %>%
      mutate(new_workpackage = ifelse(workpackage %in% selected_wp(), 1, 0)) %>%
      get_filtered_data(input_vars = input) %>%
      get_converted_date(format_var = input$sel_timegroup) %>%
      get_sum_by_group(target = duration_h, new_workpackage, new_startdate) %>%
      mutate(new_workpackage = ifelse(new_workpackage == 1, "ausgewählt", "nicht ausgewählt"))
    p <- ggplot(df, aes(x = new_startdate, y = sum_target, fill = new_workpackage)) +
      geom_bar(position = "fill", stat = "identity") +
      labs(x = "", y = "Anteil", fill = "Arbeitspaket")
    ggplotly(p)
  })
}

## To be copied in the UI
# mod_projects_ui("projects_ui_1")
    
## To be copied in the server
# callModule(mod_projects_server, "projects_ui_1")
 
