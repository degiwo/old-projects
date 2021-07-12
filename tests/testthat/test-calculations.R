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

test_that("types defense table has the right columns and coverage values", {
    pkmn_team <- list()
    pkmn_team[["pkmn1"]][["name"]] <- "Ivysaur"
    pkmn_team[["pkmn1"]][["type"]] <- list(c("Grass", "Poison"))
    pkmn_team[["pkmn1"]][["defense"]] <- data.frame(
        type = c("Normal", "Fire", "Water"),
        multiplicator = c(1.0, 2.0, 0.5)
    )
    pkmn_team[["pkmn2"]][["name"]] <- "Charizard"
    pkmn_team[["pkmn2"]][["type"]] <- list(c("Fire", "Flying"))
    pkmn_team[["pkmn2"]][["defense"]] <- data.frame(
        type = c("Normal", "Fire", "Water"),
        multiplicator = c(1.0, 0.5, 2.0)
    )
    df <- get_types_defense_table(pkmn_team)
    expect_true(all(c("weak", "resist", "immune", "coverage") %in% names(df)))
    expect_true(all(unique(df$coverage) %in% c("good", "bad", "neutral")))
})

test_that("recommended types are correct", {
    pkmn_team <- list()
    pkmn_team[["pkmn1"]][["name"]] <- "Test1"
    pkmn_team[["pkmn1"]][["type"]] <- list(c("Grass"))
    pkmn_team[["pkmn1"]][["defense"]] <- data.frame(
        type = c("Normal", "Fire", "Water", "Grass", "Flying"),
        multiplicator = c(1.0, 2.0, 0.5, 0.5, 2.0)
    )
    pkmn_team[["pkmn2"]][["name"]] <- "Test2"
    pkmn_team[["pkmn2"]][["type"]] <- list(c("Fire"))
    pkmn_team[["pkmn2"]][["defense"]] <- data.frame(
        type = c("Normal", "Fire", "Water", "Grass", "Flying"),
        multiplicator = c(1.0, 0.5, 2.0, 0.5, 1.0)
    )
    recs <- get_recommended_additions(pkmn_team)
    expect_true(all(c("Steel", "Electric", "Rock") %in% names(recs)))
})

test_that("recommended pokemon are correct", {
    temp <- c("Steel", "Steel", "Steel", "Electric")
    recs <- table(temp)
    df_pkmn <- get_recommended_pkmn(recs, show_onlyrectypes = 1)
    
    expect_true(all(df_pkmn$type1 %in% c("Steel", "Electric") | df_pkmn$type2 %in% c("Steel", "Electric")))
})

test_that("all pokemon are possible in recommended pokemon", {
    df_pokedex <- get_pokedex()
    temp <- c("Fire", "Water")
    df_pkmn <- get_recommended_pkmn(table(temp), show_onlyrectypes = FALSE)
    expect_equal(nrow(df_pkmn), nrow(df_pokedex))
})

setwd(wd)
