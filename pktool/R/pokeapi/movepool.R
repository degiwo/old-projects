library(jsonlite)
library(httr)

# Initialize empty list to store data.frames
n_pkmn <- 500
columns <- c(
  "id", "name", "move", "level", "method", "version_group"
)
list_df <- list()

# Progress bar for visualization
progressbar <- txtProgressBar(min = 0, max = n_pkmn, style = 3)

for (i in seq(n_pkmn)) {
  link <- paste0("https://pokeapi.co/api/v2/pokemon/", i)
  json_content <- content(GET(link))
  json_moves <- json_content[["moves"]]
  
  for (j in seq(json_moves)) {
    # Move pool is dependent on version group (= generation)
    version_groups <- json_moves[[j]][["version_group_details"]]
    df <- data.frame(matrix(nrow = length(version_groups), ncol = length(columns)))
    names(df) <- columns
    
    # Id, name and move
    df$id <- json_content[["id"]]
    df$name <- json_content[["name"]]
    df$move <- json_moves[[j]][["move"]][["name"]]
    
    for (k in seq(version_groups)) {
      df$level[k] <- version_groups[[k]][["level_learned_at"]]
      df$version_group[k] <- version_groups[[k]][["version_group"]][["name"]]
      df$method[k] <- version_groups[[k]][["move_learn_method"]][["name"]]
    }
    list_df <- append(list_df, list(df))
  }
  
  setTxtProgressBar(progressbar, i)
}
close(progressbar)

# Final data.frame with all moves for each pkmn & gen
df_movepool <- do.call(rbind, list_df)

# Store data
movepool <- df_movepool
use_data(movepool)
