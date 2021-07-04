library(shiny)
library(shinydashboard)
library(jsonlite)

# TODO: without source?
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
