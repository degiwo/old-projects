#' UI for Pokedex tab
#'
#' @param id 
#'
#' @importFrom shiny NS
#' @importFrom shinyWidgets checkboxGroupButtons
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
        
        column(
          width = 12,
          
          fluidRow(
            # Pre evolution ----
            column(
              width = 4,
              tableOutput(ns("txt_pre_evolution"))
            ),
            # Pokemon sprite ----
            column(
              width = 4,
              htmlOutput(ns("link_sprite"))
            ),
            # Post evolution ----
            column(
              width = 4,
              tableOutput(ns("txt_post_evolution"))
            )
          ),
          # Types ----
          fluidRow(
            textOutput(ns("txt_types"))
          ),
          # Abilities ----
          fluidRow(
            uiOutput(ns("box_abilities"))
          ),
          # Bar chart for stats ----
          fluidRow(
            plotOutput(ns("plt_stats"))
          )
        )
      ),
      
      
      box(
        status = "primary",
        
        column(
          width = 12,
          
          # Move pool ----
          selectizeInput(
            ns("btn_gen"),
            label = "Generation",
            choices = unique(movepool$version_group),
            selected = "red-blue"
          ),
          checkboxGroupButtons(
            ns("btn_method"),
            label = "Method",
            choices = unique(movepool$method),
            selected = "level-up",
            checkIcon = list(yes = icon("ok", lib = "glyphicon")),
            justified = TRUE
          ),
          fluidRow(
            tableOutput(ns("tbl_movepool"))
          )
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
#' @importFrom dplyr left_join
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
      req(input$sel_pkmn)
      paste(na.omit(c(
        pokemon$type1[pokemon$name == input$sel_pkmn],
        pokemon$type2[pokemon$name == input$sel_pkmn]
      )))
    })
    
    # Pokemon sprite ----
    output$link_sprite <- renderText({
      req(input$sel_pkmn)
      link <- paste0("https://pokeapi.co/api/v2/pokemon/", input$sel_pkmn)
      json_content <- content(GET(link))
      c('<img src="',
        json_content[["sprites"]][["front_default"]],
        '", style="display: block; margin-left: auto; margin-right: auto;">')
    })
    
    # Bar chart for stats ----
    output$plt_stats <- renderPlot({
      req(input$sel_pkmn)
      df <- pokemon %>%
        .[.$name == input$sel_pkmn, stat_cols] %>%
        pivot_longer(stat_cols, names_to = "stat", values_to = "value")
      df$stat <- factor(df$stat, levels = rev(stat_cols))
      
      ggplot(df, aes(x = stat, y = value, fill = stat)) +
        geom_bar(stat = "identity") +
        geom_text(aes(label = value, color = stat), hjust = -0.3, size = 5) +
        coord_flip() +
        theme(axis.text = element_text(size = 12), legend.position = "none") +
        # ylim(0, 255) +
        scale_y_continuous(n.breaks = 6, limits = c(0, 255)) +
        labs(x = "", y = "", fill = "")
    })
    
    # Abilities ----
    output$box_abilities <- renderUI({
      req(input$sel_pkmn)
      df <- pokemon %>%
        .[.$name == input$sel_pkmn, ability_cols] %>%
        pivot_longer(ability_cols, names_to = "slot", values_to = "ability") %>%
        na.omit()
      lapply(seq(df$slot), function(i) {
        box(
          width = floor(12 / length(df$slot)),
          title = paste(df$ability[i], ifelse(df$slot[i] == "ability-hidden", "(HA)", "")),
          abilities$short_desc[abilities$name == df$ability[i]][1]
        )
      })
    })
    
    # Move pool ----
    output$tbl_movepool <- renderTable({
      req(input$sel_pkmn)
      req(input$btn_method)
      req(input$btn_gen)
      df <- movepool %>%
        .[.$name == input$sel_pkmn, ] %>%
        .[.$method %in% input$btn_method, ] %>%
        .[.$version_group %in% input$btn_gen, ] %>%
        left_join(moves, by = c("move" = "name")) %>%
        .[order(.$level),  c("level", "move", "type", "dmg_class",
                             "power", "accuracy", "method")]
    })
    
    # Pre evolution ----
    output$txt_pre_evolution <- renderTable({
      req(input$sel_pkmn)
      if (sum(evolution$evolves_to == input$sel_pkmn) > 0) {
        df <- evolution %>%
          .[.$evolves_to == input$sel_pkmn, ]
        # TODO: Refactor in a function
        df$condition <- ifelse(
          # Friendship
          !is.na(df$friendship), "Friendship",
          ifelse(
            # Use item
            df$trigger == "use-item", paste0("Use ", df$item),
            ifelse(
              # Trade
              df$trigger == "trade", paste0(
                df$trigger, ifelse(!is.na(df$held_item), paste0(": ", df$held_item), "")
              ),
              # Level up
              paste0(df$trigger, ifelse(
                !is.na(df$held_item), paste0(": ", df$held_item), ifelse(
                  !is.na(df$min_level), paste0(": ", df$min_level), ""
                )
              ))
            )
          )
        )
        df$evolves_from <- df$name
        df <- df[, c("evolves_from", "condition")]
      }
    })
    
    # Post evolution ----
    output$txt_post_evolution <- renderTable({
      req(input$sel_pkmn)
      
      if (sum(evolution$name == input$sel_pkmn) > 0) {
        df <- evolution %>%
          .[.$name == input$sel_pkmn, ]
        # TODO: Refactor in a function
        df$condition <- ifelse(
          # Friendship
          !is.na(df$friendship), "Friendship",
          ifelse(
            # Use item
            df$trigger == "use-item", paste0("Use ", df$item),
            ifelse(
              # Trade
              df$trigger == "trade", paste0(
                df$trigger, ifelse(!is.na(df$held_item), paste0(": ", df$held_item), "")
              ),
              # Level up
              paste0(df$trigger, ifelse(
                !is.na(df$held_item), paste0(": ", df$held_item), ifelse(
                  !is.na(df$min_level), paste0(": ", df$min_level), ""
                )
              ))
            )
          )
        )
        df <- df[, c("evolves_to", "condition")]
      }
    })
    
  })
}
