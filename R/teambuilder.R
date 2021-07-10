teambuilderUI <- function(id) {
    ns <- NS(id)

    tagList(
        h2("Teambuilder"),

        # pkmn selections ---------------------------------------------------------

        fluidRow(
            lapply(1:3, function(i) {
                column(
                    width = 4,
                    selectizeInput(ns(paste0("sel_pkmn", i)), "Choose Pok\u00E9mon", choices = NULL),
                    tableOutput(ns(paste0("tbl_pkmn", i)))
                )
            })
        ),
        fluidRow(
            lapply(4:6, function(i) {
                column(
                    width = 4,
                    selectizeInput(ns(paste0("sel_pkmn", i)), "Choose Pok\u00E9mon", choices = NULL),
                    tableOutput(ns(paste0("tbl_pkmn", i)))
                )
            })
        ),
        

        # type table --------------------------------------------------------------

        tableOutput(ns("tbl_types_defense")),
        textOutput(ns("recommended_additions"))
    )
}

teambuilderServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        # Data management ---------------------------------------------------------

        pokedex <- reactive({
            get_pokedex()
        })
        
        pkmn_team <- reactiveValues()
        
        lapply(1:6, function(i) {
            observe({
                updateSelectizeInput(inputId = paste0("sel_pkmn", i), choices = pokedex()$name, options = list(
                    onInitialize = I('function() { this.setValue(""); }')
                ))
            })
        })
        
        lapply(1:6, function(i) {
            observeEvent(input[[paste0("sel_pkmn", i)]], {
                pkmn <- input[[paste0("sel_pkmn", i)]]
                pokedex <- pokedex()
                df <- pokedex[pokedex$name == pkmn, c("name", "type", "type1", "type2")]
                
                pkmn_team[[paste0("pkmn", i)]][["name"]] <- pkmn
                pkmn_team[[paste0("pkmn", i)]][["type"]] <- df$type
                pkmn_team[[paste0("pkmn", i)]][["defense"]] <- get_defense_multiplicators(df$type1[1], df$type2[1])
                
                # rename columns to prevent merge warnings
                df <- pkmn_team[[paste0("pkmn", i)]][["defense"]]
                names(pkmn_team[[paste0("pkmn", i)]][["defense"]])[names(df) != "type"] <- paste(names(df)[names(df) != "type"], i)
            })
        })


        # Render output elements --------------------------------------------------

        lapply(1:6, function(i) {
            output[[paste0("tbl_pkmn", i)]] <- renderTable({
                req(input[[paste0("sel_pkmn", i)]])
                df_def <- pkmn_team[[paste0("pkmn", i)]][["defense"]]
                df <- data.frame(
                    type = paste(unlist(pkmn_team[[paste0("pkmn", i)]][["type"]]), collapse = ","),
                    weak = paste(df_def$type[df_def$multiplicator > 1], collapse = ","),
                    resists = paste(df_def$type[df_def$multiplicator < 1 & df_def$multiplicator > 0], collapse = ","),
                    immune = paste(df_def$type[df_def$multiplicator == 0], collapse = ",")
                )
                t(df)
            }, rownames = TRUE, colnames = FALSE)
        })

        output$tbl_types_defense <- renderTable({
            x <- reactiveValuesToList(input)
            req(any(x[grep("sel_pkmn", names(x))] != ""))
            
            df <- get_types_defense_table(pkmn_team)
                        
            # customize appearance of table
            rownames(df) <- df$type
            df$type <- NULL
            df <- subset(df, select = -grep("multiplicator", names(df)))
            t(df)
        }, rownames = TRUE, colnames = TRUE)
        
        output$recommended_additions <- renderText({
            x <- reactiveValuesToList(input)
            req(any(x[grep("sel_pkmn", names(x))] != "") && !all(x[grep("sel_pkmn", names(x))] != ""))
            paste0(
                "Recommended Addtitions: ",
                get_recommended_additions(pkmn_team)
            )
        })
    })
}
