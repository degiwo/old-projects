teambuilderUI <- function(id) {
    ns <- NS(id)

    tagList(
        h2("Teambuilder"),
        selectizeInput(ns("sel_pkmn"), "Choose Pok\u00E9mon", choices = NULL),
        tableOutput(ns("tbl_pkmn")),
        tableOutput(ns("tbl_types_defense"))
    )
}

teambuilderServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        # Data management ---------------------------------------------------------

        pokedex <- reactive({
            get_pokedex()
        })
        types <- reactive({
            get_types()
        })
        
        pkmn_team <- reactiveValues()
        
        observe({
            updateSelectizeInput(inputId = "sel_pkmn", choices = pokedex()$name)
        })
        
        observeEvent(input$sel_pkmn, {
            pokedex <- pokedex()
            df <- pokedex[pokedex$name == input$sel_pkmn, c("name", "type", "type1", "type2")]
            
            pkmn_team$pkmn1[["name"]] <- input$sel_pkmn
            pkmn_team$pkmn1[["type"]] <- df$type
            pkmn_team$pkmn1[["defense"]] <- get_defense_multiplicators(df$type1[1], df$type2[1])
        })

        
        # Render output elements --------------------------------------------------

        output$tbl_pkmn <- renderTable({
            req(input$sel_pkmn)
            df_def <- pkmn_team$pkmn1[["defense"]]
            df <- data.frame(
                name = pkmn_team$pkmn1[["name"]],
                type = paste(pkmn_team$pkmn1[["type"]], collapse = ","),
                weak = paste(df_def$type[df_def$multiplicator > 1], collapse = ","),
                resists = paste(df_def$type[df_def$multiplicator < 1 & df_def$multiplicator > 0], collapse = ","),
                immune = paste(df_def$type[df_def$multiplicator == 0], collapse = ",")
            )
            t(df)
        }, rownames = TRUE, colnames = FALSE)

        output$tbl_types_defense <- renderTable({
            req(input$sel_pkmn)
            df <- pkmn_team$pkmn1[["defense"]]
            df$weak <- ifelse(df$multiplicator > 1, 1, 0)
            df$resist <- ifelse(df$multiplicator < 1 & df$multiplicator > 0, 1, 0)
            df$immune <- ifelse(df$multiplicator == 0, 1, 0)
            df$multiplicator <- NULL
            t(df)
        }, rownames = TRUE, colnames = FALSE)
    })
}
