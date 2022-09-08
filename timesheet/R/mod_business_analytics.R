#' business_analytics UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList
#' @import shinyWidgets
mod_business_analytics_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Business Analytics"),
    fluidRow(
      column(
        3,
        pickerInput_(ns("sel_employee"), label = "Mitarbeiter", multiple = TRUE)
      ),
      column(
        3,
        pickerInput_(ns("sel_year"), label = "Jahr", multiple = TRUE)
      ),
      column(
        3,
        radioGroupButtons(ns("sel_abs_rel"), label = "test", choices = c("PT", "%40h", "%100"), selected = "PT")
      )
    ),
    pivottablerOutput(ns("tbl_pivot"))
  )
}
    
#' business_analytics Server Function
#'
#' @noRd 
#' 
#' @import pivottabler
mod_business_analytics_server <- function(input, output, session, df_ba){
  ns <- session$ns
  
  observe({
    choices <- c("DWON", "CSAR", "GFRA")
    updatePickerInput(session, "sel_employee", choices = choices, selected = NULL)
  })
  
  observe({
    choices <- sort(unique(substr(df_ba()$zeitraum, 1, 4)), decreasing = TRUE)
    updatePickerInput(session, "sel_year", choices = choices, selected = NULL)
  })
  
  
  output$tbl_pivot <- renderPivottabler({
    req(input$sel_employee)
    req(input$sel_year)
    year_filter <- paste0(input$sel_year, "-")
    
    df_targets <- get_target_days()
    
    withProgress(message = "Calculation pivot table", value = 0, {
      df <- df_ba() %>%
        # vacation days
        bind_rows(get_vacation_days()) %>%
        # filter by selections
        filter(`kürzel` %in% input$sel_employee) %>%
        filter(grepl(year_filter, zeitraum)) %>%
        # relative zu full time equivalent
        left_join(df_targets, by = c("zeitraum" = "month")) %>%
        mutate(rel40 = round(ts_pt_zu_8_std / days * 100, 2)) %>%
        # relative to 100%
        group_by(`kürzel`, zeitraum) %>%
        mutate(rel100 = round(ts_pt_zu_8_std / sum(ts_pt_zu_8_std) * 100, 2)) %>%
        ungroup()
      pt <- PivotTable$new()
      pt$addData(df)
      pt$addColumnDataGroups("zeitraum")
      pt$addRowDataGroups("kürzel",
                          outlineBefore = list(isEmpty = FALSE, groupStyleDeclarations=list(color="blue")),
                          outlineTotal = list(groupStyleDeclarations=list(color="blue")))
      pt$addRowDataGroups("project_name", addTotal = FALSE)
      incProgress(1/2)
      if (input$sel_abs_rel == "PT") {
        pt$defineCalculation(calculationName = "PT", summariseExpression = "sum(ts_pt_zu_8_std)")
      } else if (input$sel_abs_rel == "%40h") {
        pt$defineCalculation(calculationName = "PT", summariseExpression = "sum(rel40)")
      } else {
        pt$defineCalculation(calculationName = "PT", summariseExpression = "sum(rel100)")
      }
      pt$evaluatePivot()
      incProgress(1/2)
    })

    pivottabler(pt)
  })
}
    
## To be copied in the UI
# mod_business_analytics_ui("business_analytics_ui_1")
    
## To be copied in the server
# callModule(mod_business_analytics_server, "business_analytics_ui_1")
 
