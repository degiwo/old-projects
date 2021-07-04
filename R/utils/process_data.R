library(jsonlite)

get_pokedex <- function() {
    pokedex <- fromJSON(readLines("../data/pokedex.json"), flatten = TRUE)
    
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
