#' UI for Pokedex tab
#'
#' @param id 
#'
#' @importFrom shiny NS
#' @noRd
pokedexUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Title ----
    h2("Pokedex"),
    
    # Input: Choose Pokemon ----
    selectizeInput(ns("sel_pkmn"), label = "Choose Pokemon", choices = pokemon$name),
    
    fluidRow(
      box(
        status = "primary",
        # Pokemon sprite ----
        htmlOutput(ns("link_sprite")),
        # Types ----
        textOutput(ns("txt_types")),
        # Abilities ----
        uiOutput(ns("box_abilities")),
        # Bar chart for stats ----
        plotOutput(ns("plt_stats"))
      )
    )
  )
}

#' Server for Pokedex tab
#'
#' @param id 
#'
#' @import shiny
#' @import ggplot2
#' @importFrom magrittr %>%
#' @importFrom tidyr pivot_longer
#' @importFrom stats na.omit
#' @importFrom httr GET content
#' @noRd
pokedexServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # global module settings ----
    stat_cols <- c("hp", "attack", "defense", "special-attack", "special-defense", "speed")
    ability_cols <- c("ability1", "ability2", "ability-hidden")
    
    # Types ----
    output$txt_types <- renderText({
      paste(na.omit(c(
        pokemon$type1[pokemon$name == input$sel_pkmn],
        pokemon$type2[pokemon$name == input$sel_pkmn]
      )))
    })
    
    # Pokemon sprite ----
    output$link_sprite <- renderText({
      link <- paste0("https://pokeapi.co/api/v2/pokemon/", input$sel_pkmn)
      json_content <- content(GET(link))
      c('<img src="',
        json_content[["sprites"]][["front_default"]],
        '", style="display: block; margin-left: auto; margin-right: auto;">')
    })
    
    # Bar chart for stats ----
    output$plt_stats <- renderPlot({
      df <- pokemon %>%
        .[.$name == input$sel_pkmn, stat_cols] %>%
        pivot_longer(stat_cols, names_to = "stat", values_to = "value")
      df$stat <- factor(df$stat, levels = rev(stat_cols))
      
      ggplot(df, aes(x = stat, y = value, fill = stat)) +
        geom_bar(stat = "identity") +
        geom_text(aes(label = value, color = stat), hjust = -0.3, size = 5) +
        coord_flip() +
        theme(axis.text = element_text(size = 12), legend.position = "none") +
        labs(x = "", y = "", fill = "")
    })
    
    # Abilities ----
    output$box_abilities <- renderUI({
      df <- pokemon %>%
        .[.$name == input$sel_pkmn, ability_cols] %>%
        pivot_longer(ability_cols, names_to = "slot", values_to = "ability") %>%
        na.omit()
      lapply(seq(df$slot), function(i) {
        box(
          width = 12 / length(df$slot),
          title = paste(df$ability[i], ifelse(df$slot[i] == "ability-hidden", "(HA)", "")),
          "Description"
        )
      })
    })
    
  })
}
