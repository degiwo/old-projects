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
    fileInput(ns("file_in"),
              label = "Choose images",
              multiple = FALSE,
              accept = c("image/png", ".png")),

    actionButton(ns("btn_predict"),
                 label = "Predict!"),

    textOutput(ns("file_class"))
  )
}

#' file_upload Server Function
#'
#' @noRd
#'
#' @import magrittr
mod_file_upload_server <- function(input, output, session) {
  ns <- session$ns

  output$file_class <- renderText({
    req(input$file_in)

    file_cls <- input$file_in$datapath %>%
      prep_img_for_nn() %>%
      predict_image() %>%
      convert_pred_to_class()
  })
}
