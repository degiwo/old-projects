#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny shinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    dashboardPage(
      dashboardHeader(title = "timesheet"),
      dashboardSidebar(
        sidebarMenu(
          menuItem("Übersicht", tabName = "tab_dashboard", icon = icon("dashboard")),
          menuItem("Projekte", tabName = "tab_projects", icon = icon("chart-bar")),
          menuItem("Business Analytics", tabName = "tab_business_analytics", icon = icon("database")),
          menuItem("Detailsicht", tabName = "tab_detail", icon = icon("info"))
        )
      ),
      dashboardBody(
        tabItems(
          tabItem(tabName = "tab_dashboard", mod_dashboard_ui("tab_dashboard")),
          tabItem(tabName = "tab_projects", mod_projects_ui("tab_projects")),
          tabItem(tabName = "tab_business_analytics", mod_business_analytics_ui("tab_business_analytics")),
          tabItem(tabName = "tab_detail", mod_detail_ui("tab_detail"))
        )
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'timesheet'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

