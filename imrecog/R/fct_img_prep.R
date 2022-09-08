#' Parse a png file into a matrix with numbers
#'
#' @param img path to image
#' @return a matrix
#'
#' @noRd
#'
#' @importFrom imager load.image resize grayscale
#' @import magrittr
prep_img_for_nn <- function(img) {
  prep_img <- img %>%
    load.image() %>%
    resize(28, 28) %>%
    grayscale() %>%
    as.data.frame() %>%
    .$value %>%
    matrix(nrow = 28, ncol = 28)

  return(prep_img)
}
