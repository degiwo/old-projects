context("test server helper functions for projectview")

test_that("entries without workpackage get a dummy workpackage", {
  test_data <- data.frame(
    workpackage = c(NA, "abc", "def", NA),
    duration = 1:4,
    stringsAsFactors = FALSE
  )
  result <- set_name_for_workpackages(test_data)
  expected_result <- data.frame(
    workpackage = c("OHNE AP", "abc", "def", "OHNE AP"),
    duration = 1:4,
    stringsAsFactors = FALSE
  )

  expect_equal(result, expected_result)
})

test_that("duration is summarized correctly", {
  test_data <- data.frame(
    workpackage = c("abc", "abc", "def", "abc"),
    duration = c(1, 2.3, 4.9, 7.2),
    stringsAsFactors = FALSE
  )
  result <- get_summarised_duration(test_data)
  expected_result <- data.frame(
    workpackage = c("abc", "def"),
    sum_duration = c(1+2.3+7.2, 4.9),
    stringsAsFactors = FALSE
  )
  
  expect_equal(result, expected_result)
})
