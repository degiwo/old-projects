#' Predict with the model from a image parsed to matrix.
#'
#' @param input a matrix
#' @return integer
#'
#' @noRd
#'
#' @importFrom keras array_reshape predict_classes load_model_hdf5
#' @import magrittr
predict_image <- function(input) {
  prep_input <- input %>%
    array_reshape(c(1, 28, 28, 1))

  model <- load_model_hdf5("C:/Users/dwong/Desktop/imrecog/dev/nn_model.h5")

  pred <- model %>%
    predict_classes(prep_input)

  return(pred)
}

#' Get the class from the prediction value.
#'
#' @param pred a integer
#' @return text
#'
#' @noRd
convert_pred_to_class <- function(pred) {
  if (pred == 0) {
    cls <- "Breze"
  } else {
    cls <- "Semmel"
  }

  return(cls)
}
