#' UI for Pokedex tab
#'
#' @param id 
#'
#' @importFrom shiny NS
#' @noRd
pokedexUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    h2("Pokedex"),
    
    selectizeInput(ns("sel_pkmn"), label = "Pokemon", choices = pokemon$name),
    textOutput(ns("txt_types"))
  )
}

#' Server for Pokedex tab
#'
#' @param id 
#'
#' @import shiny
#' @importFrom stats na.omit
#' @noRd
pokedexServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$txt_types <- renderText({
      paste(na.omit(c(
        pokemon$type1[pokemon$name == input$sel_pkmn],
        pokemon$type2[pokemon$name == input$sel_pkmn]
      )))
    })
  })
}
