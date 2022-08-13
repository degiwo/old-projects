context("test module projectview")

library(golem)

test_that("ui is a shiny element", {
  expect_shinytaglist(mod_projectview_ui(1))
})

test_that("server is a function", {
  expect_is(mod_projectview_server, "function")
})
