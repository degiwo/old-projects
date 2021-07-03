teambuilderUI <- function(id) {
    ns <- NS(id)
    
    tagList(
        h2("Teambuilder"),
        selectizeInput(ns("sel_pkmn"), "Choose Pok\u00E9mon", choices = c("AA", "BB")),
        textOutput(ns("txt_pkmn"))
    )
}

teambuilderServer <- function(input, output, session) {
    output$txt_pkmn <- renderText(input$sel_pkmn)
}
