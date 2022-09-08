pickerInput_ <- function(inputId, label = NULL, choices = NULL, selected = NULL, multiple = FALSE,
                         options = list(`actions-box` = TRUE, `live-search` = TRUE)) {
  return(pickerInput(inputId, label = label, choices = choices, selected = selected,
                     multiple = multiple, options = options))
}
