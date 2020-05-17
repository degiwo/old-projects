#' projectview UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_projectview_ui <- function(id) {
  ns <- NS(id)
  tagList()
}

#' projectview Server Function
#'
#' @noRd
mod_projectview_server <- function(input, output, session) {
  ns <- session$ns
}
