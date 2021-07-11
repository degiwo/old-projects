library(jsonlite)

get_generations <- function() {
    gen <- 1:8
    names(gen) <- paste("Gen", as.roman(gen))
    return(gen)
}

get_legendaries <- function() {
    legendaries <- read.csv2("../data/legendaries.csv")
    names(legendaries)[1] <- "id"
    return(legendaries)
}

get_pokedex <- function() {
    pokedex <- fromJSON(readLines("../data/pokedex.json"), flatten = TRUE)
    
    # modify columns: type1, type2, total
    pokedex$type1 <- apply(pokedex, 1, function(x) {
        if(length(x$type) == 1)
            x$type
        else
            x$type[1]
    })
    pokedex$type2 <- apply(pokedex, 1, function(x) {
        if(length(x$type) == 1)
            NA
        else
            x$type[2]
    })
    pokedex$total <- pokedex$base.HP + pokedex$base.Attack + pokedex$base.Defense +
        pokedex$`base.Sp. Attack` + pokedex$`base.Sp. Defense` + pokedex$base.Speed
    
    # add information about generation
    pokedex$gen <- cut(pokedex$id, c(1, 152, 252, 387, 494, 650, 722, 810, Inf),
                       labels = 1:8, include.lowest = TRUE, right = FALSE)
    
    # add information about legendaries
    legendaries <- get_legendaries()
    pokedex$legend <- ifelse(pokedex$id %in% legendaries$id, 1, 0)
    
    names(pokedex)[names(pokedex) == "name.english"] <- "name"
    return(pokedex)
}

get_defense_type_effects <- function() {
    defense_type_effects <- fromJSON(readLines("../data/defense_type_effects.json"), flatten = TRUE)
    
    return(defense_type_effects)
}

get_offense_type_effects <- function() {
    offense_type_effects <- fromJSON(readLines("../data/offense_type_effects.json"), flatten = TRUE)
    
    return(offense_type_effects)
}
