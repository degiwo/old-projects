#' Wrapper got get_golem_version
#'
#' @importFrom golem get_golem_version
#' @noRd
print_version_in_footer <- function() {
  tags$footer(paste0("Version: v", get_golem_version()),
              style = "position:absolute; bottom:0; padding: 10px"
  )
}
