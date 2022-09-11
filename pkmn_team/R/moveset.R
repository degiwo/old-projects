movesetUI <- function(id) {
    ns <- NS(id)
    
    tagList(
        h2("Moveset"),
        fluidRow(
            lapply(1:3, function(i) {
                column(
                    width = 4,
                    textOutput(ns(paste0("txt_pkmn", i))),
                    lapply(1:4, function(j) {
                        selectizeInput(ns(paste0("sel_pkmn", i, "_move", j)), label = "", choices = NULL)
                    })
                )
                
            })
        ),
        fluidRow(
            lapply(4:6, function(i) {
                column(
                    width = 4,
                    textOutput(ns(paste0("txt_pkmn", i))),
                    lapply(1:4, function(j) {
                        selectizeInput(ns(paste0("sel_pkmn", i, "_move", j)), label = "", choices = NULL)
                    })
                )
                
            })
        )
    )
}

movesetServer <- function(id, pkmn_team) {
    moduleServer(id, function(input, output, session) {
        
        lapply(1:6, function(i) {
            output[[paste0("txt_pkmn", i)]] <- renderText({
                pkmn_team[[paste0("pkmn", i)]][["name"]]
            })
            
            lapply(1:4, function(j) {
                observe({
                    updateSelectizeInput(inputId = paste0("sel_pkmn", i, "_move", j),
                                         session = session,
                                         choices = get_moves_list(pkmn_team[[paste0("pkmn", i)]][["name"]]),
                                         selected = NULL,
                                         options = list(onInitialize = I('function() { this.setValue(""); }'))
                                         )
                })
            })

        })

    })
}
