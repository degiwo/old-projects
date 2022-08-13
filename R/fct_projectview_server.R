#' Automatically update the costcenter dropdown
#'
#' @noRd
update_costcenter_dropdown <- function(session, rct_timesheet) {
  observe({
    choices <- unique(rct_timesheet()$costcenter)

    updatePickerInput(session,
      "sel_costcenter",
      choices = sort(choices)
    )
  })
}

#' Automatically update the workpackage dropdown
#'
#' @noRd
update_workpackage_dropdown <- function(input, session, rct_timesheet) {
  observe({
    new_choices <- rct_timesheet()$workpackage[rct_timesheet()$costcenter ==
      input$sel_costcenter]

    updatePickerInput(session,
      "sel_workpackage",
      choices = sort(unique(new_choices)),
      selected = unique(new_choices)
    )
  })
}

#' Get only entries of selected project/workpackge
#'
#' @import dplyr
#' @noRd
filter_by_selection <- function(input, data_timesheet) {
  df <- data_timesheet %>%
    filter(costcenter == input$sel_costcenter) %>%
    filter(workpackage %in% input$sel_workpackage)
  
  return(df)
}

#' Summarize the duration by workpackage
#'
#' @import dplyr
#' @noRd
get_summarised_duration <- function(data_timesheet) {
  df <- data_timesheet %>%
    group_by(costcenter, workpackage) %>%
    summarise(sum_duration = sum(duration))
  
  return(df)
}
