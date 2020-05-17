## code to prepare `timesheet_raw` dataset goes here

n <- 150
costcenters <- as.character(1001:1010)
employees <- paste("Mitarbeiter", 1:5)
workpackages <- paste("Arbeitspaket", 1:3)
startdates <- as.Date(18000:18500, origin = "1970-01-01")

set.seed(123)
timesheet_raw <- data.frame(
  costcenter = sample(costcenters, size = n, replace = TRUE),
  scheduleid = seq(n),
  employee = sample(employees, size = n, replace = TRUE),
  workpackage = sample(workpackages, size = n, replace = TRUE),
  startdate = sample(startdates, size = n, replace = TRUE),
  duration = round(runif(n, min = 0.12, max = 8), 2)
)

usethis::use_data(timesheet_raw, overwrite = TRUE)
