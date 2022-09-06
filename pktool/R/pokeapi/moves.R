library(jsonlite)
library(httr)

# Initialize empty data.frame
n_moves <- 800
columns <- c(
  "id", "name", "power", "accuracy", "pp", "priority",
  "dmg_class", "type"
)
df_moves <- data.frame(matrix(nrow = n_moves, ncol = length(columns)))
names(df_moves) <- columns

# Progress bar for visualization
progressbar <- txtProgressBar(min = 0, max = n_moves, style = 3)

for (i in seq(n_moves)) {
  link <- paste0("https://pokeapi.co/api/v2/move/", i)
  json_content <- content(GET(link))
  
  # Id and name
  df_moves$id[i] <- json_content[["id"]]
  df_moves$name[i] <- json_content[["name"]]
  
  # further information
  if (!is.null(json_content[["power"]])) df_moves$power[i] <- json_content[["power"]]
  if (!is.null(json_content[["accuracy"]])) df_moves$accuracy[i] <- json_content[["accuracy"]]
  df_moves$pp[i] <- json_content[["pp"]]
  df_moves$priority[i] <- json_content[["priority"]]
  
  df_moves$dmg_class[i] <- json_content[["damage_class"]][["name"]]
  df_moves$type[i] <- json_content[["type"]][["name"]]
  
  
  setTxtProgressBar(progressbar, i)
}
close(progressbar)

# Store data
moves <- df_moves
use_data(moves, overwrite = TRUE)
