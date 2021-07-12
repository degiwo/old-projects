
# pokedex -----------------------------------------------------------------

prepare_pokedex <- function() {
    json <- fromJSON("data/raw/pokemon.json")
    
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
    pokedex$type <- apply(pokedex, 1, function(x) {
        ifelse(!is.na(x["type2"]), paste0(c(x["type1"], x["type2"]), collapse = ','), x["type1"])
    })
    pokedex$base.HP <- as.integer(pokedex$baseStats.hp)
    pokedex$base.Attack <- as.integer(pokedex$baseStats.atk)
    pokedex$base.Defense <- as.integer(pokedex$baseStats.def)
    pokedex$`base.Sp. Attack` <- as.integer(pokedex$baseStats.spa)
    pokedex$`base.Sp. Defense` <- as.integer(pokedex$baseStats.spd)
    pokedex$base.Speed <- as.integer(pokedex$baseStats.spe)
    pokedex$id <- as.integer(pokedex$num)
    pokedex$total <- pokedex$base.HP + pokedex$base.Attack + pokedex$base.Defense +
        pokedex$`base.Sp. Attack` + pokedex$`base.Sp. Defense` + pokedex$base.Speed
    
    return(pokedex)
}

pokedex <- prepare_pokedex()
saveRDS(pokedex, "data/prepared/pokedex.rds")
rm(pokedex)
