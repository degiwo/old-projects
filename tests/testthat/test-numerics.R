test_that("plot_histogram() returns ggplot", {
  expect_type(plot_histogram(mtcars, "mpg"), "list")
  expect(grepl("gg", class(plot_histogram(mtcars, "mpg"))[1]), "plot_histogram() does not return gg")
})
