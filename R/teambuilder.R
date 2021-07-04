teambuilderUI <- function(id) {
    ns <- NS(id)

    tagList(
        h2("Teambuilder"),
        fluidRow(
            column(
                width = 4,
                selectizeInput(ns("sel_pkmn1"), "Choose Pok\u00E9mon", choices = NULL),
                tableOutput(ns("tbl_pkmn1"))
            ),
            column(
                width = 4,
                selectizeInput(ns("sel_pkmn2"), "Choose Pok\u00E9mon", choices = NULL),
                tableOutput(ns("tbl_pkmn2"))
            ),
            column(
                width = 4,
                selectizeInput(ns("sel_pkmn3"), "Choose Pok\u00E9mon", choices = NULL),
                tableOutput(ns("tbl_pkmn3"))
            )
        ),
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
        
        lapply(1:3, function(i) {
            observe({
                updateSelectizeInput(inputId = paste0("sel_pkmn", i), choices = pokedex()$name)
            })
        })
        
        lapply(1:3, function(i) {
            observeEvent(input[[paste0("sel_pkmn", i)]], {
                pkmn <- input[[paste0("sel_pkmn", i)]]
                pokedex <- pokedex()
                df <- pokedex[pokedex$name == pkmn, c("name", "type", "type1", "type2")]
                
                pkmn_team[[paste0("pkmn", i)]][["name"]] <- pkmn
                pkmn_team[[paste0("pkmn", i)]][["type"]] <- df$type
                pkmn_team[[paste0("pkmn", i)]][["defense"]] <- get_defense_multiplicators(df$type1[1], df$type2[1])
            })
        })


        # Render output elements --------------------------------------------------

        lapply(1:3, function(i) {
            output[[paste0("tbl_pkmn", i)]] <- renderTable({
                req(input[[paste0("sel_pkmn", i)]])
                df_def <- pkmn_team[[paste0("pkmn", i)]][["defense"]]
                df <- data.frame(
                    name = pkmn_team[[paste0("pkmn", i)]][["name"]],
                    type = paste(pkmn_team[[paste0("pkmn", i)]][["type"]], collapse = ","),
                    weak = paste(df_def$type[df_def$multiplicator > 1], collapse = ","),
                    resists = paste(df_def$type[df_def$multiplicator < 1 & df_def$multiplicator > 0], collapse = ","),
                    immune = paste(df_def$type[df_def$multiplicator == 0], collapse = ",")
                )
                t(df)
            }, rownames = TRUE, colnames = FALSE)
        })

        output$tbl_types_defense <- renderTable({
            req(input$sel_pkmn1)
            df <- pkmn_team$pkmn1[["defense"]]
            df$weak <- ifelse(df$multiplicator > 1, 1, 0)
            df$resist <- ifelse(df$multiplicator < 1 & df$multiplicator > 0, 1, 0)
            df$immune <- ifelse(df$multiplicator == 0, 1, 0)
            df$multiplicator <- NULL
            t(df)
        }, rownames = TRUE, colnames = FALSE)
    })
}
