# This script scrapes Pokemon information from https://pokeapi.co/

library(jsonlite)
library(httr)

# Initialize empty data.frame
n_pkmn <- 300
columns <- c(
  "id", "name", "type1", "type2",
  "hp", "attack", "defense",
  "special-attack", "special-defense", "speed",
  "ability1", "ability2", "ability-hidden"
)
df_pkmn <- data.frame(matrix(nrow = n_pkmn, ncol = length(columns)))
names(df_pkmn) <- columns

# Progress bar for visualization
progressbar <- txtProgressBar(min = 0, max = n_pkmn, style = 3)

for (i in seq(n_pkmn)) {
  link <- paste0("https://pokeapi.co/api/v2/pokemon/", i)
  json_content <- content(GET(link))
  
  # Id and name
  df_pkmn$id[i] <- json_content[["id"]]
  df_pkmn$name[i] <- json_content[["name"]]
  
  # Types
  if (length(json_content[["types"]]) > 2) {
    warning(paste("More than 2 types for", json_content[["name"]]))
  }
  for (j in seq(json_content[["types"]])) {
    df_pkmn[i, paste0("type", j)] <- json_content[["types"]][[j]][["type"]][["name"]]
  }
  
  # Stats
  for (j in seq(json_content[["stats"]])) {
    stat_name <- json_content[["stats"]][[j]][["stat"]][["name"]]
    df_pkmn[i, stat_name] <- json_content[["stats"]][[j]][["base_stat"]]
  }
  
  # Abilities
  if (length(json_content[["abilities"]]) > 3) {
    warning(paste("More than 3 abilities for", json_content[["name"]]))
  }
  for (j in seq(json_content[["abilities"]])) {
    ability_slot <- ifelse(
      json_content[["abilities"]][[j]][["is_hidden"]], "ability-hidden", 
      paste0("ability", json_content[["abilities"]][[j]][["slot"]])
    )
    df_pkmn[i, ability_slot] <- json_content[["abilities"]][[j]][["ability"]][["name"]]
  }
  
  setTxtProgressBar(progressbar, i)
}
close(progressbar)

# Store data
pokemon <- df_pkmn
use_data(pokemon, overwrite = TRUE)
