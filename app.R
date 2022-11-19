library(shiny)
library(DT)

# Define UI for application
ui <- fluidPage(

  # Application title
  titlePanel("Renegade Platinum"),
  DTOutput("dt_stats")
)

# Define server logic
server <- function(input, output) {
  stats <- read.csv("data/stats.csv", sep = ";", encoding = "UTF-8")
  
  output$dt_stats <- renderDT({
    stats
  })
}

# Run the application
shinyApp(ui = ui, server = server)
