movesetUI <- function(id) {
    ns <- NS(id)
    
    tagList(
        h2("Moveset"),
        textOutput(ns("txt_pkmn1")),
        selectizeInput(ns("sel_pkmn1_move1"), label = "", choices = NULL)
    )
}

movesetServer <- function(id, pkmn_team) {
    moduleServer(id, function(input, output, session) {
        output$txt_pkmn1 <- renderText({
            pkmn_team[[paste0("pkmn", 1)]][["name"]]
        })
        
        observe({
            updateSelectizeInput(inputId = "sel_pkmn1_move1",
                                 session = session,
                                 choices = get_moves_list(pkmn_team[[paste0("pkmn", 1)]][["name"]]))
        })
    })
}
