context("test server helper functions for projectview")

test_that("entries without workpackage get a dummy workpackage", {
  test_data <- data.frame(
    workpackage = c(NA, "abc", "def", NA),
    duration = 1:4
  )
  result <- set_name_for_workpackages(test_data)
  expected_result <- data.frame(
    workpackage = c("OHNE AP", "abc", "def", "OHNE AP"),
    duration = 1:4
  )

  expect_equal(result, expected_result)
})
