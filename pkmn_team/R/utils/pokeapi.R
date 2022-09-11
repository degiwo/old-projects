library(httr)

get_moves_list <- function(pkmn_name) {
    link <- paste0("https://pokeapi.co/api/v2/pokemon/", tolower(pkmn_name))
    r <- GET(link)
    moves <- lapply(content(r)$moves, function(x) {
        unlist(x)["move.name"]
    })
    
    return(as.character(unlist(moves)))
}
