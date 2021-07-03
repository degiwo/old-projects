teambuilderUI <- function(id) {
    ns <- NS(id)
    
    tagList(
        h2("Teambuilder"),
        selectizeInput(ns("sel_pkmn"), "Choose Pok\u00E9mon", choices = NULL),
        tableOutput(ns("tbl_pkmn"))
    )
}

teambuilderServer <- function(id, pokedex) {
    moduleServer(id, function(input, output, session) {
        observe({
            updateSelectizeInput(inputId = "sel_pkmn", choices = pokedex()$name.english)
        })
        
        output$tbl_pkmn <- renderTable({
            req(input$sel_pkmn)
            pokedex <- pokedex()
            df <- pokedex[pokedex$name.english == input$sel_pkmn, c("name.english", "type1", "type2")]
            df$weaknesses <- paste(unique(get_weaknesses(df$type1[1], df$type2[1])), collapse = ", ")
            t(df)
        }, rownames = TRUE, colnames = FALSE)
    })
}
    
    
