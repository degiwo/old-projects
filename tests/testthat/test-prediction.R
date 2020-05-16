context("prediction tests")

test_that("predict_image returns 0 or 1", {
  img <- matrix(1, nrow = 28, ncol = 28)
  pred <- predict_image(img)

  expect_true(pred %in% 0:1)
})
