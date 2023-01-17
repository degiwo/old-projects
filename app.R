library(shiny)
library(DT)
library(dplyr)


STATS_NAMES <- c(
  "Name",
  "HP_Orig",
  "Atk_Orig",
  "Def_Orig",
  "SpA_Orig",
  "SpD_Orig",
  "Spe_Orig",
  "Total_Orig",
  "HP",
  "Atk",
  "Def",
  "SpA",
  "SpD",
  "Spe",
  "Total",
  "Type1_Orig",
  "Type2_Orig",
  "Type1",
  "Type2",
  "Ability1_Orig",
  "Ability2_Orig",
  "Ability1",
  "Ability2",
  "ItemHeld1",
  "ItemHeld2",
  "Exp_Growth",
  "Catch_Rate",
  "Base_Friendship",
  "Evolution_Method"
)

ENCOUNTERS_NAMES <- c(
  "Milestone",
  "Location",
  "Name",
  "Method",
  "Notes",
  "Events"
)

read_stats <- function() {
  stats <- read.csv("data/stats.csv", sep = ";", encoding = "UTF-8")
  names(stats) <- STATS_NAMES
  
  stats[1] <- apply(stats[1], 1, function(x) unlist(strsplit(x, "#(.[^A-Z]*) "))[2])
  return(stats)
}

read_encounters <- function() {
  encounters <- read.csv("data/encounters.csv", sep = ";", encoding = "UTF-8")
  names(encounters) <- ENCOUNTERS_NAMES
  
  encounters["Min_Level"] <- as.integer(ifelse(grepl("Lv.", encounters$Method), substr(encounters$Method, 5, 6), 0))
  encounters <- encounters %>%
    mutate(Location = as.factor(Location)) %>%
    mutate(Milestone = as.factor(Milestone))
  return(encounters)
}


# Define UI for application
ui <- fluidPage(

  # Application title
  titlePanel("Renegade Platinum"),
  
  # Table
  DTOutput("dt_stats")
)

# Define server logic
server <- function(input, output) {
  stats <- read_stats()
  encounters <- read_encounters()

  output$dt_stats <- renderDT({
    stats %>%
      left_join(encounters, by = "Name") %>%
      select(
        "Name",
        "HP",
        "Atk",
        "Def",
        "SpA",
        "SpD",
        "Spe",
        "Total",
        "Type1",
        "Type2",
        "Ability1",
        "Ability2",
        "Milestone",
        "Method",
        "Min_Level"
      ) %>%
      filter(Milestone != "Legendary") %>%
      datatable(filter = 'top')
  })
}

# Run the application
shinyApp(ui = ui, server = server)
