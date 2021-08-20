#' business_analytics UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
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
    
    withProgress(message = "Calculation pivot table", value = 0, {
      df <- df_ba() %>%
        filter(`kürzel` %in% input$sel_employee) %>%
        filter(grepl(year_filter, zeitraum))
      pt <- PivotTable$new()
      pt$addData(df)
      pt$addColumnDataGroups("zeitraum")
      pt$addRowDataGroups("kürzel",
                          outlineBefore = list(isEmpty = FALSE, groupStyleDeclarations=list(color="blue")),
                          outlineTotal = list(groupStyleDeclarations=list(color="blue")))
      pt$addRowDataGroups("project_name", addTotal = FALSE)
      incProgress(1/2)
      pt$defineCalculation(calculationName = "PT", summariseExpression = "sum(ts_pt_zu_8_std)")
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
 
