#' file_upload UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_file_upload_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fileInput(ns("files_in"),
              label = "Choose images",
              multiple = TRUE,
              accept = c("image/png", ".png")),

    textOutput(ns("files_name"))
  )
}

#' file_upload Server Function
#'
#' @noRd
mod_file_upload_server <- function(input, output, session) {
  ns <- session$ns

  output$files_name <- renderText({
    req(input$files_in)

    input$files_in$name
  })
}
