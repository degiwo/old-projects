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
    #pokedex <- fromJSON(readLines("../data/pokedex.json"), flatten = TRUE)
    json <- fromJSON("../data/pokemon.json")
    
    collapsed_df <- tibble::enframe(unlist(json))
    collapsed_df$header <- apply(collapsed_df, 1, function(x) regmatches(x, regexpr("\\.", x), invert = TRUE)[[1]][1])
    collapsed_df$colname <- apply(collapsed_df, 1, function(x) regmatches(x, regexpr("\\.", x), invert = TRUE)[[1]][2])
    
    pokedex <- pivot_wider(collapsed_df[, c("value", "header", "colname")], names_from = colname, values_from = value)
    
    # modify columns: type1, type2, total
    pokedex$type1 <- apply(pokedex, 1, function(x) {
        if(!is.na(x["types"]))
            x["types"]
        else
            x["types1"]
    })
    pokedex$type2 <- pokedex$types2
    pokedex$type <- pokedex$types
    pokedex$base.HP <- as.integer(pokedex$baseStats.hp)
    pokedex$base.Attack <- as.integer(pokedex$baseStats.atk)
    pokedex$base.Defense <- as.integer(pokedex$baseStats.def)
    pokedex$`base.Sp. Attack` <- as.integer(pokedex$baseStats.spa)
    pokedex$`base.Sp. Defense` <- as.integer(pokedex$baseStats.spd)
    pokedex$base.Speed <- as.integer(pokedex$baseStats.spe)
    pokedex$id <- as.integer(pokedex$num)
    pokedex$total <- pokedex$base.HP + pokedex$base.Attack + pokedex$base.Defense +
        pokedex$`base.Sp. Attack` + pokedex$`base.Sp. Defense` + pokedex$base.Speed
    
    # add information about generation
    pokedex$gen <- cut(pokedex$id, c(1, 152, 252, 387, 494, 650, 722, 810, Inf),
                       labels = 1:8, include.lowest = TRUE, right = FALSE)
    
    # add information about legendaries
    legendaries <- get_legendaries()
    pokedex$legend <- ifelse(pokedex$id %in% legendaries$id, 1, 0)
    
    #names(pokedex)[names(pokedex) == "name.english"] <- "name"
    pokedex <- subset(pokedex, select = c(id, name, type, type1, type2, gen, legend, total, base.HP, base.Attack, base.Defense, `base.Sp. Attack`, `base.Sp. Defense`, base.Speed))
    pokedex <- pokedex[!pokedex$name == "MissingNo.", ]
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
