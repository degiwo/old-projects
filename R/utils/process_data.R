library(jsonlite)

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
