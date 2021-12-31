library(jsonlite)
library(httr)

# Initialize empty list to store the data.frames which will be binded
n_evo <- 467
columns <- c(
  "id", "name", "evolves_to",
  "trigger", "min_level", "held_item", "item", "friendship"
)
list_df <- list()

# Helper function to unchain evolves_to
unchain_evolves_to <- function(json, id) {
  if (length(json[["evolves_to"]]) > 0) {
    # Initialize empty data.frame, rows = number of pkmn evolves to
    df <- data.frame(matrix(nrow = length(json[["evolves_to"]]), ncol = length(columns)))
    names(df) <- columns
    
    # Fill data
    df$id <- id
    df$name <- json[["species"]][["name"]]
    for (j in seq(json[["evolves_to"]])) {
      json_evolves_to <- json[["evolves_to"]][[j]]
      df$evolves_to[j] <- json_evolves_to[["species"]][["name"]]
      # TODO: decompose all evolution possibilities
      if (length(json_evolves_to[["evolution_details"]]) > 0) {
        df$trigger[j] <- json_evolves_to[["evolution_details"]][[1]][["trigger"]][["name"]]
        if (!is.null(json_evolves_to[["evolution_details"]][[1]][["min_level"]])) {
          df$min_level[j] <- json_evolves_to[["evolution_details"]][[1]][["min_level"]]
        }
        if (!is.null(json_evolves_to[["evolution_details"]][[1]][["min_happiness"]])) {
          df$friendship[j] <- !is.null(json_evolves_to[["evolution_details"]][[1]][["min_happiness"]])
        }
        if (!is.null(json_evolves_to[["evolution_details"]][[1]][["item"]])) {
          df$item[j] <- json_evolves_to[["evolution_details"]][[1]][["item"]]
        }
        if (!is.null(json_evolves_to[["evolution_details"]][[1]][["held_item"]])) {
          df$held_item[j] <- json_evolves_to[["evolution_details"]][[1]][["held_item"]]
        }
      }
    }
    
    # held_item and item was somehow parsed as logical
    df$held_item <- as.character(df$held_item)
    df$item <- as.character(df$item)
    return(df)
  }
}

# Progress bar for visualization
progressbar <- txtProgressBar(min = 0, max = n_evo, style = 3)

# Main script
for (i in seq(n_evo)) {
  link <- paste0("https://pokeapi.co/api/v2/evolution-chain/", i)
  json_content <- content(GET(link))
  if (length(json_content) == 1) next # "Not Found" as response
  json_chain <- json_content[["chain"]]
  
  # Unchain evolves_to
  # TODO: chain complete?
  list_df <- append(list_df, list(unchain_evolves_to(json_chain, i)))
  for (j in seq(json_chain[["evolves_to"]])) {
    list_df <- append(list_df, list(unchain_evolves_to(json_chain[["evolves_to"]][[j]], i)))
  }
  
  setTxtProgressBar(progressbar, i)
}
close(progressbar)

# Final data.frame
df_evolution <- do.call(rbind, list_df)

# Store data
evolution <- df_evolution
use_data(evolution, overwrite = TRUE)
