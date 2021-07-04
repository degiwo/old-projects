source("R/utils/calculations.R")
wd <- getwd()
setwd("R")

test_that("get_defense_multiplicators returns all needed columns", {
    df_mult <- get_defense_multiplicators("Grass", "Poison")
    expect_true(all(c("type", "multiplicator") %in% names(df_mult)))
})

test_that("defense multiplicators are calculated correctly",  {
    df_mult <- get_defense_multiplicators("Grass", "Poison")
    expect_equal(df_mult$multiplicator[df_mult$type == "Fire"], 2)
    expect_equal(df_mult$multiplicator[df_mult$type == "Fairy"], 0.5)
    
    df_mult <- get_defense_multiplicators("Dragon", "Ground")
    expect_equal(df_mult$multiplicator[df_mult$type == "Electric"], 0)
    expect_equal(df_mult$multiplicator[df_mult$type == "Ice"], 4)
    expect_equal(df_mult$multiplicator[df_mult$type == "Flying"], 1)
})

setwd(wd)
