#' Automatically update the costcenter dropdown
#'
#' @noRd
update_costcenter_dropdown <- function(session, data_timesheet) {
  observe({
    choices <- unique(data_timesheet()$costcenter)

    updatePickerInput(session,
      "sel_costcenter",
      choices = sort(choices)
    )
  })
}

#' Automatically update the workpackage dropdown
#'
#' @noRd
update_workpackage_dropdown <- function(input, session, data_timesheet) {
  observe({
    new_choices <- data_timesheet()$workpackage[data_timesheet()$costcenter ==
      input$sel_costcenter]

    updatePickerInput(session,
      "sel_workpackage",
      choices = sort(unique(new_choices)),
      selected = unique(new_choices)
    )
  })
}
