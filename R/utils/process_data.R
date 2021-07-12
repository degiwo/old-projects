library(jsonlite)

get_generations <- function() {
    gen <- 1:8
    names(gen) <- paste("Gen", as.roman(gen))
    return(gen)
}

get_legendaries <- function() {
    legendaries <- read.csv2("../data/raw/legendaries.csv")
    names(legendaries)[1] <- "id"
    return(legendaries)
}

get_pokedex <- function() {
    pokedex <- readRDS("../data/prepared/pokedex.rds")    
    # add information about generation
    pokedex$gen <- cut(pokedex$id, c(1, 152, 252, 387, 494, 650, 722, 810, Inf),
                       labels = 1:8, include.lowest = TRUE, right = FALSE)
    
    # add information about legendaries
    legendaries <- get_legendaries()
    pokedex$legend <- ifelse(pokedex$id %in% legendaries$id, 1, 0)
    
    # remove gmax pokemon
    pokedex <- pokedex[!grepl("-Gmax", pokedex$name), ]
    
    pokedex <- subset(pokedex,
                      select = c(id, name, type, type1, type2, gen, legend, total,
                                 base.HP, base.Attack, base.Defense,
                                 `base.Sp. Attack`, `base.Sp. Defense`, base.Speed,
                                 abilities.0, abilities.1, abilities.H, abilities.S,
                                 evos
                                 )
                      )
    
    # remove other pokemon
    pokedex <- pokedex[!grepl("Pikachu-", pokedex$name), ]
    pokedex <- pokedex[!grepl("Pichu-", pokedex$name), ]
    pokedex <- pokedex[!grepl("Castform-", pokedex$name), ]
    pokedex <- pokedex[!grepl("-Totem", pokedex$name), ]
    pokedex <- pokedex[!pokedex$name == "MissingNo.", ]
    return(pokedex)
}

get_defense_type_effects <- function() {
    defense_type_effects <- fromJSON(readLines("../data/raw/defense_type_effects.json"), flatten = TRUE)
    
    return(defense_type_effects)
}

get_offense_type_effects <- function() {
    offense_type_effects <- fromJSON(readLines("../data/raw/offense_type_effects.json"), flatten = TRUE)
    
    return(offense_type_effects)
}
