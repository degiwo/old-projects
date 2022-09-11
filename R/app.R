library(shiny)
library(shinydashboard)
library(DT)
library(shinyWidgets)
library(jsonlite)
library(tidyr)

source("utils/process_data.R")
source("utils/calculations.R")
source("utils/pokeapi.R")
source("teambuilder.R")
source("moveset.R")

myApp <- function(...) {
    ui <- dashboardPage(
        header = dashboardHeader(title = "Pokémon Team"),
        sidebar = dashboardSidebar(
            sidebarMenu(
                menuItem("Teambuilder", tabName = "tab_teambuilder")
            ),
            sidebarMenu(
                menuItem("Moveset", tabName = "tab_moveset")
            )
        ),
        body = dashboardBody(
            # Include the custom styling
            tags$head(
                tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
            ),
            
            tabItems(
                tabItem(tabName = "tab_teambuilder", teambuilderUI("tab_teambuilder")),
                tabItem(tabName = "tab_moveset", movesetUI("tab_moveset"))
            )
        )
    )
    server <- function(input, output, session) {
        pkmn_team <- reactiveValues()
        
        teambuilderServer("tab_teambuilder", pkmn_team)
        movesetServer("tab_moveset", pkmn_team)
    }
    shinyApp(ui, server, ...)
}

myApp()
