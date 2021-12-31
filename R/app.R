#' Run the pktool application.
#'
#' @export
#' @import shinydashboard
#' @importFrom shiny shinyApp
run_app <- function() {
  ui <- dashboardPage(
    dashboardHeader(title = "Pktool"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Pokedex", tabName = "tab_pokedex", icon = icon("tablet")),
        menuItem("Evolution Line", tabName = "tab_evolution", icon = icon("layer-group"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "tab_pokedex", pokedexUI("tab_pokedex")),
        tabItem(tabName = "tab_evolution", evolutionUI("tab_evolution"))
      )
    )
  )
  server <- function(input, output, session) {
    pokedexServer("tab_pokedex")
    evolutionServer("tab_evolution")
  }
  return(shinyApp(ui, server))
}
