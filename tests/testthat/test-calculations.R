source("R/utils/calculations.R")
wd <- getwd()
setwd("R")

test_that("get_defense_multiplicators returns all needed columns", {
    df_mult <- get_defense_multiplicators("Grass", "Poison", "Chlorophyll")
    expect_true(all(c("type", "multiplicator") %in% names(df_mult)))
})

test_that("defense multiplicators are calculated correctly",  {
    df_mult <- get_defense_multiplicators("Grass", "Poison", "Chlorophyll")
    expect_equal(df_mult$multiplicator[df_mult$type == "Fire"], 2)
    expect_equal(df_mult$multiplicator[df_mult$type == "Fairy"], 0.5)
    
    df_mult <- get_defense_multiplicators("Dragon", "Ground", "Levitate")
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
    temp <- c("Steel", "Steel", "Steel", "Fairy")
    recs <- table(temp)
    df_pkmn <- get_recommended_pkmn(recs)
    df_pkmn <- df_pkmn[!is.na(df_pkmn$prio_type), ]
    
    expect_true(all(df_pkmn$type1 %in% c("Steel", "Fairy") |
                        df_pkmn$type2 %in% c("Steel", "Fairy")))
})

test_that("all pokemon are possible in recommended pokemon", {
    df_pokedex <- get_pokedex()
    temp <- c()
    df_pkmn <- get_recommended_pkmn(table(temp))
    expect_equal(nrow(df_pkmn), nrow(df_pokedex))
})

test_that("abilities are also recommended", {
    pkmn_team <- list()
    pkmn_team[["pkmn1"]][["name"]] <- "Test1"
    pkmn_team[["pkmn1"]][["type"]] <- list(c("Grass"))
    pkmn_team[["pkmn1"]][["defense"]] <- data.frame(
        type = c("Normal", "Fire", "Water", "Grass", "Ground", "Ice"),
        multiplicator = c(1.0, 2.0, 0.5, 0.5, 2.0, 2.0)
    )
    pkmn_team[["pkmn2"]][["name"]] <- "Test2"
    pkmn_team[["pkmn2"]][["type"]] <- list(c("Fire"))
    pkmn_team[["pkmn2"]][["defense"]] <- data.frame(
        type = c("Normal", "Fire", "Water", "Grass", "Ground", "Ice"),
        multiplicator = c(1.0, 1.0, 2.0, 0.5, 1.0, 1.0)
    )
    recs <- get_recommended_additions(pkmn_team)
    expect_true(all(c("Flash Fire", "Levitate", "Thick Fat") %in% names(recs)))
})

test_that("types_defense_table considers ability immunities", {
    pkmn_team <- list()
    pkmn_team[["pkmn1"]][["name"]] <- "Test"
    pkmn_team[["pkmn1"]][["type"]] <- list(c("Grass"))
    pkmn_team[["pkmn1"]][["defense"]] <- data.frame(
        type = c("Normal", "Fire", "Water", "Ground"),
        multiplicator = c(1.0, 2.0, 0.5, 2.0)
    )
    pkmn_team[["pkmn1"]][["ability"]] <- "Levitate"
    
    
    pkmn_team[["pkmn2"]][["name"]] <- "Test2"
    pkmn_team[["pkmn2"]][["type"]] <- list(c("Fire"))
    pkmn_team[["pkmn2"]][["defense"]] <- data.frame(
        type = c("Normal", "Fire", "Water", "Grass", "Ground"),
        multiplicator = c(1.0, 1.0, 2.0, 0.5, 1.0)
    )
    df <- get_types_defense_table(pkmn_team)
    expect_true(df$coverage[df$type == "Ground"] == "good")
    
})

setwd(wd)
