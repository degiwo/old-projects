library(shiny)
library(shinydashboard)
library(DT)
library(shinyWidgets)
library(jsonlite)

source("utils/process_data.R")
source("utils/calculations.R")
source("teambuilder.R")

myApp <- function(...) {
    ui <- dashboardPage(
        header = dashboardHeader(title = "Pokémon Team"),
        sidebar = dashboardSidebar(
            sidebarMenu(
                menuItem("Teambuilder", tabName = "tab_teambuilder")
            )
        ),
        body = dashboardBody(
            # Include the custom styling
            tags$head(
                tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
            ),
            
            tabItems(
                tabItem(tabName = "tab_teambuilder", teambuilderUI("tab_teambuilder"))
            )
        )
    )
    server <- function(input, output, session) {
        teambuilderServer("tab_teambuilder")
    }
    shinyApp(ui, server, ...)
}

myApp()
