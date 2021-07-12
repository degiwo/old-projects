teambuilderUI <- function(id) {
    ns <- NS(id)

    tagList(
        h2("Teambuilder"),

        # pkmn selections ---------------------------------------------------------

        fluidRow(
            column(
                width = 1,
                actionButton(ns("clear_pkmn"), label = "Clear all")
            ),
            column(
                width = 11,
                checkboxGroupButtons(ns("btns_choose_gen"),
                                     choices = get_generations(),
                                     selected = 1:8,
                                     checkIcon = list(
                                         yes = icon("check-square"),
                                         no = icon("square-o"))
                                     )
            )
        ),
        fluidRow(
            lapply(1:3, function(i) {
                column(
                    width = 4,
                    selectizeInput(ns(paste0("sel_pkmn", i)), "", choices = NULL),
                    tableOutput(ns(paste0("tbl_pkmn", i)))
                )
            })
        ),
        fluidRow(
            lapply(4:6, function(i) {
                column(
                    width = 4,
                    selectizeInput(ns(paste0("sel_pkmn", i)), "", choices = NULL),
                    tableOutput(ns(paste0("tbl_pkmn", i)))
                )
            })
        ),
        

        # type table --------------------------------------------------------------

        tableOutput(ns("tbl_types_defense")),
        textOutput(ns("recommended_additions")),
        tags$br(),
        box(
            title = "Pok\u00E9mon recommendations",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            collapsible = TRUE,
            collapsed = TRUE,
            fluidRow(
                column(
                    width = 3,
                    materialSwitch(ns("show_legendaries"), label = "Include Legendaries", value = TRUE, status = "primary")
                ),
                column(
                    width = 3,
                    materialSwitch(ns("show_megas"), label = "Include Megas", value = TRUE, status = "primary")
                ),
                column(
                    width = 3,
                    materialSwitch(ns("show_onlyfullyevolved"), label = "Only fully evolved", value = TRUE, status = "primary")
                ),
                column(
                    width = 3,
                    materialSwitch(ns("show_allpkmn"), label = "All availables", value = TRUE, status = "primary")
                )
            ),
            DTOutput(ns("tbl_recommended_pkmn"))
        )
    )
}

teambuilderServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        # Data management ---------------------------------------------------------

        pokedex <- reactive({
            get_pokedex()
        })
        
        pkmn_team <- reactiveValues()
        recommended_additions <- reactiveVal()
        
        lapply(1:6, function(i) {
            observe({
                updateSelectizeInput(inputId = paste0("sel_pkmn", i),
                                     choices = pokedex()$name,
                                     server = TRUE, # server side, see Performance note
                                     options = list(onInitialize = I('function() { this.setValue(""); }'))
                )
            })
        })
        
        # add selected pkmn to pkmn_team
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
        
        # get recommended additions
        lapply(1:6, function(i) {
            observeEvent(input[[paste0("sel_pkmn", i)]], {
                x <- reactiveValuesToList(input)
                req(any(x[grep("sel_pkmn", names(x))] != ""))
                
                # store recommended additions as a table in a reactiveVal
                recommended_additions(get_recommended_additions(pkmn_team))
            })
        })
        
        # clear all button
        observeEvent(input$clear_pkmn, {
            lapply(1:6, function(i) {
                observe({
                    updateSelectizeInput(inputId = paste0("sel_pkmn", i),
                                         choices = pokedex()$name,
                                         selected = NULL,
                                         options = list(onInitialize = I('function() { this.setValue(""); }'))
                    )
                })
            })
        })
        
        # filter pokemon of chosen generations
        observeEvent(input$btns_choose_gen, {
            filtered_pkmn <- pokedex()$name[pokedex()$gen %in% input$btns_choose_gen]
            lapply(1:6, function(i) {
                observe({
                    updateSelectizeInput(inputId = paste0("sel_pkmn", i),
                                         choices = filtered_pkmn,
                                         selected = isolate(pkmn_team[[paste0("pkmn", i)]][["name"]]),
                                         options = list(onInitialize = I('function() { this.setValue(""); }')),
                                         server = TRUE # server side, see Performance note
                    )
                })
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
            req(any(x[grep("sel_pkmn", names(x))] != ""))
            rec_types <- names(sort(-recommended_additions()))
            paste0(
                "Recommended Addtitions: ",
                paste0(rec_types, collapse = ",")
            )
        })
        
        output$tbl_recommended_pkmn <- renderDT({
            # render table if selection is made
            input$sel_pkmn1
            input$sel_pkmn2
            input$sel_pkmn3
            input$sel_pkmn4
            input$sel_pkmn5
            input$sel_pkmn6
            input$show_legendaries
            
            req(recommended_additions())
            df <- get_recommended_pkmn(recommended_additions, input$show_allpkmn)
            # filter generations
            df <- df[df$gen %in% input$btns_choose_gen, ]
            
            # filter legendaries
            if (!input$show_legendaries) {
                df <- df[df$legend == 0, ]
            }
            
            # filter megas
            if (!input$show_megas) {
                df <- df[!grepl("-Mega", df$name), ]
            }
            
            # filter not fully evolved
            if (!input$show_onlyfullyevolved) {
                df <- df[is.na(df$evos), ]
            }
            
            df <- subset(df, select = c("name", "type", "total",
                                        "base.HP", "base.Attack",
                                        "base.Defense", "base.Sp. Attack",
                                        "base.Sp. Defense", "base.Speed"))
            datatable(df, filter = "top")
        })
    })
}
