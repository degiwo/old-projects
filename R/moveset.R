movesetUI <- function(id) {
    ns <- NS(id)
    
    tagList(
        h2("Moveset")
    )
}

movesetServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        
    })
}
