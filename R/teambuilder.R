teambuilderUI <- function(id) {
    ns <- NS(id)
    
    tagList(
        h2("Teambuilder"),
        selectizeInput(ns("sel_pkmn"), "Choose Pok\u00E9mon", choices = pokedex$name.english),
        tableOutput(ns("tbl_pkmn"))
    )
}

teambuilderServer <- function(input, output, session) {
    output$tbl_pkmn <- renderTable({
        df <- pokedex[pokedex$name.english == input$sel_pkmn, c("name.english", "type1", "type2")]
        df$weaknesses <- paste(unique(get_weaknesses(df$type1[1], df$type2[1])), collapse = ", ")
        t(df)
    }, rownames = TRUE, colnames = FALSE)
}
