teambuilderUI <- function(id) {
    ns <- NS(id)

    tagList(
        h2("Teambuilder"),
        selectizeInput(ns("sel_pkmn"), "Choose Pok\u00E9mon", choices = NULL),
        tableOutput(ns("tbl_pkmn")),
        tableOutput(ns("tbl_types_defense"))
    )
}

teambuilderServer <- function(id, pokedex, types) {
    moduleServer(id, function(input, output, session) {
        observe({
            updateSelectizeInput(inputId = "sel_pkmn", choices = pokedex()$name.english)
        })

        output$tbl_pkmn <- renderTable({
            req(input$sel_pkmn)
            pokedex <- pokedex()
            df <- pokedex[pokedex$name.english == input$sel_pkmn, c("name.english", "type1", "type2")]
            df$weaknesses <- paste(unique(get_weaknesses(df$type1[1], df$type2[1])), collapse = ", ")
            df$resistances <- paste(unique(get_resistances(df$type1[1], df$type2[1])), collapse = ", ")
            df$immunities <- paste(unique(get_immunities(df$type1[1], df$type2[1])), collapse = ", ")
            t(df)
        }, rownames = TRUE, colnames = FALSE)

        output$tbl_types_defense <- renderTable({
            req(input$sel_pkmn)
            pokedex <- pokedex()
            type1 <- pokedex$type1[pokedex$name.english == input$sel_pkmn]
            type2 <- pokedex$type2[pokedex$name.english == input$sel_pkmn]
            weaks <- get_weaknesses(type1, type2)
            
            df <- sapply(types()$english, function(x) sum(x %in% weaks))
            df <- data.frame(df)
            names(df) <- c("weak")
            t(df)
        }, rownames = TRUE)
    })
}
