# Created with 'use_test("hello")'

test_that("hello() prints 'Hello World!'", {
  expect_output(hello(), "Hello World!")
})
