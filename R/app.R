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
        menuItem("Pokedex", tabName = "tab_pokedex", icon = icon("tablet"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "tab_pokedex", pokedexUI("tab_pokedex"))
      )
    )
  )
  server <- function(input, output, session) {
    pokedexServer("tab_pokedex")
  }
  return(shinyApp(ui, server))
}
