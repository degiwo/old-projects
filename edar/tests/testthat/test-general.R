test_that("skim_data() works", {
  expect_type(skim_data(mtcars), "list")
  expect_equal(nrow(skim_data(mtcars)), 11)
})
