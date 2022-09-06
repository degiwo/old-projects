# functions to analyze the data overall

#' Skim data
#'
#' @description Return data.frame with the columns and the corresponding type.
#'
#' @param data data.frame
#'
#' @return data.frame
#' @importFrom utils head
skim_data <- function(data) {
  df_skim <- data.frame(
    columns = names(data),
    type = sapply(data, class),
    sample_data = sapply(
      lapply(data, function(x) head(x, 3)),
      function(x) paste(x, collapse = " | ")
    ),
    row.names = NULL
  )
  return(df_skim)
}
