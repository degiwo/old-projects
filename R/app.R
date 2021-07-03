library(shiny)

myApp <- function(...) {
    ui <- fluidPage(
        h1("Shiny App")
    )
    server <- function(input, output, session) {

    }
    shinyApp(ui, server, ...)
}

myApp()
