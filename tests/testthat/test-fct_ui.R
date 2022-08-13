context("ui helper function tests")

library(golem)

test_that("ui_header is a shiny element", {
  expect_shinytag(ui_header())
})

test_that("ui_sidebar is a shiny element", {
  expect_shinytag(ui_sidebar())
})

test_that("ui_body is a shiny element", {
  expect_shinytag(ui_body())
})
