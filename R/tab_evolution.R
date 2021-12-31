#' UI for Pokedex tab
#'
#' @param id 
#'
#' @importFrom shiny NS
#' @importFrom shinyWidgets checkboxGroupButtons
#' @noRd
evolutionUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Title ----
    h2("Evolution Line"),
    
    # Input: Choose Pokemon ----
    selectizeInput(ns("sel_pkmn"), label = "Choose Pokemon", choices = pokemon$name),
    
    fluidRow(
      box(
        status = "primary",
        width = 12,
        
        # Line chart: stats of evolution line ----
        column(
          width = 10,
          plotOutput(ns("plt_evo_line"))
        ),
        column(
          width = 2,
          
          # Select stat to plot in line chart ----
          # choices will be set in server function
          radioButtons(ns("sel_stat"), label = "Select stat", choices = NA)
        )
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
#' @noRd
evolutionServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # global module settings ----
    stat_cols <- c("hp", "attack", "defense", "special_attack", "special_defense", "speed")
    ability_cols <- c("ability1", "ability2", "ability_hidden")
    
    # evolution line id as reactive
    reac_evo_id <- reactive({
      unique(evolution$id[evolution$name == input$sel_pkmn | evolution$evolves_to == input$sel_pkmn])
    })
    
    # Line chart: stats of evolution line ----
    output$plt_evo_line <- renderPlot({
      req(input$sel_pkmn)
      df <- evolution %>%
        .[.$id == reac_evo_id(), ]
      all_pkmn_of_evo_line <- unique(c(df$name, df$evolves_to, input$sel_pkmn))
      # create new row for base evolution form
      for (i in seq(all_pkmn_of_evo_line)) {
        if (!all_pkmn_of_evo_line[i] %in% df$evolves_to) {
          new_row <- data.frame(matrix(nrow = 1, ncol = ncol(df)))
          names(new_row) <- names(df)
          new_row$evolves_to[1] <- all_pkmn_of_evo_line[i]
          new_row$min_level[1] <- 0
          df <- rbind(new_row, df) %>%
            left_join(pokemon, by = c("evolves_to" = "name")) %>%
          .[, c("evolves_to", "min_level", stat_cols)]
        }
      }
      ggplot(df, aes_string(x = "min_level", y = input$sel_stat)) +
        geom_line() +
        geom_point(aes(color = evolves_to)) +
        geom_text(aes_string(label = input$sel_stat), vjust = -0.5) +
        ylim(0, NA) +
        xlim(0, NA)
    })
    
    # Select stat to plot in line chart ----
    updateRadioButtons(
      session,
      "sel_stat",
      choices = stat_cols
    )
    
  })
}
