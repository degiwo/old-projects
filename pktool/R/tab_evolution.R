#' UI for Pokedex tab
#'
#' @param id 
#'
#' @importFrom shiny NS
#' @importFrom shinyWidgets awesomeCheckboxGroup
#' @noRd
evolutionUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Title ----
    h2("Evolution Line"),
    
    # Input: Choose Pokemon ----
    selectizeInput(ns("sel_pkmn"), label = "Choose Pokemon", choices = pokemon$name, multiple = TRUE),
    
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
          awesomeCheckboxGroup(ns("sel_stat"), label = "Select stat", choices = NA)
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
#' @importFrom tidyr pivot_longer
#' @noRd
evolutionServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # global module settings ----
    stat_cols <- c("hp", "attack", "defense", "special_attack", "special_defense", "speed")
    ability_cols <- c("ability1", "ability2", "ability_hidden")
    
    # evolution line id as reactive
    reac_evo_id <- reactive({
      unique(evolution$id[evolution$name %in% input$sel_pkmn | evolution$evolves_to %in% input$sel_pkmn])
    })
    
    # Line chart: stats of evolution line ----
    output$plt_evo_line <- renderPlot({
      req(input$sel_pkmn)
      req(input$sel_stat)
      df <- evolution %>%
        .[.$id %in% reac_evo_id(), ]
      all_pkmn_of_evo_line <- unique(c(df$name, df$evolves_to, input$sel_pkmn))
      # create new row for base evolution form
      for (i in seq(all_pkmn_of_evo_line)) {
        if (!all_pkmn_of_evo_line[i] %in% df$evolves_to) {
          new_row <- data.frame(matrix(nrow = 1, ncol = ncol(df)))
          names(new_row) <- names(df)
          new_row$name[1] <- all_pkmn_of_evo_line[i]
          new_row$evolves_to[1] <- all_pkmn_of_evo_line[i]
          new_row$min_level[1] <- 0
          new_row$id[1] <- unique(df$id[df$name == all_pkmn_of_evo_line[i]])
          df <- rbind(new_row, df)
        }
      }
      df <- df %>%
        left_join(pokemon[, names(pokemon) != "id"], by = c("evolves_to" = "name")) %>%
        .[, c("id", "evolves_to", "min_level", stat_cols)]
      # new column for total value
      df$total <- df$hp + df$attack + df$defense +
        df$special_attack + df$special_defense + df$speed
      # wide to long
      df_long <- df %>%
        pivot_longer(cols = c("total", stat_cols), names_to = "stat", values_to = "value") %>%
        .[.$stat %in% input$sel_stat, ]
      
      ggplot(df_long, aes(x = min_level, y = value, color = factor(id))) +
        geom_line(aes(linetype = stat)) +
        geom_point(size = 5) +
        geom_text(aes(label = value), vjust = -0.8) +
        ylim(0, NA) +
        xlim(0, NA) +
        labs(x = "Level", y = "Value", linetype = "", color = "Line")
    })
    
    # Select stat to plot in line chart ----
    updateCheckboxGroupInput(
      session,
      "sel_stat",
      choices = c("total", stat_cols),
      selected = "total"
    )
    
  })
}
