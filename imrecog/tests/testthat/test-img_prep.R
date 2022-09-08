context("image prep tests")

test_that("image preparation works", {
  df_img <- prep_img_for_nn("bild.png")

  expect_equal(df_img[1,1], 1)
  expect_equal(df_img[21,16], 0.3374902)
})
