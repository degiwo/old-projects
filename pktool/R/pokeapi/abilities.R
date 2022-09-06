library(jsonlite)
library(httr)

# Initialize empty list to store data.frames
n_abilities <- 320
columns <- c(
  "id", "name", "name_de", "language", "gen", "short_desc"
)
list_df <- list()

# Progress bar for visualization
progressbar <- txtProgressBar(min = 0, max = n_abilities, style = 3)

for (i in seq(n_abilities)) {
  link <- paste0("https://pokeapi.co/api/v2/ability/", i)
  json_content <- content(GET(link))
  
  if (length(json_content) > 1) {
    json_flavor_texts <- json_content[["flavor_text_entries"]]
    
    # Initialize empty data.frame
    df <- data.frame(matrix(nrow = length(json_flavor_texts), ncol = length(columns)))
    names(df) <- columns
    
    # Id and name
    df$id <- json_content[["id"]]
    df$name <- json_content[["name"]]
    
    for (j in seq(json_flavor_texts)) {
      df$language[j] <- json_flavor_texts[[j]][["language"]][["name"]]
      df$gen[j] <- json_flavor_texts[[j]][["version_group"]][["name"]]
      df$short_desc[j] <- json_flavor_texts[[j]][["flavor_text"]]
    }
  }
  
  list_df <- append(list_df, list(df))
  setTxtProgressBar(progressbar, i)
}
close(progressbar)

# Final data.frame with all abilities and filter the relevant
df_abilities <- do.call(rbind, list_df)
df_abilities <- df_abilities[df_abilities$language == "en" & df_abilities$gen == "sword-shield", ]

# Store data
abilities <- df_abilities
use_data(abilities, overwrite = TRUE)
