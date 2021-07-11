source("R/utils/process_data.R")
wd <- getwd()
setwd("R")

test_that("pokedex has all needed columns",  {
    pokedex <- get_pokedex()
    expect_true(all(c("name", "type", "type1", "type2", "base.HP", "base.Attack", "gen") %in% names(pokedex)))
})

test_that("gen is correct", {
    pokedex <- get_pokedex()
    expect_true(all(pokedex$gen %in% 1:8))
})

test_that("defense_type_effects has all needed columns",  {
    defense_type_effects <- get_defense_type_effects()
    expect_true(all(c("name", "weaknesses", "resists", "immunes") %in% names(defense_type_effects)))
})

test_that("offense_type_effects has all needed columns",  {
    offense_type_effects <- get_offense_type_effects()
    expect_true(all(c("name", "immuned_by", "resisted_by", "effective") %in% names(offense_type_effects)))
})

test_that("all files have the same type namings", {
    pokedex <- get_pokedex()
    defense_type_effects <- get_defense_type_effects()
    expected_types <- c("Normal", "Fire", "Water", "Grass", "Electric", "Bug",
                        "Poison", "Ground", "Fairy", "Psychic", "Fighting",
                        "Rock", "Ghost", "Ice", "Dragon", "Dark", "Steel", "Flying")
    
    all_types <- unique(c(pokedex$type1, pokedex$type2, defense_type_effects$name))
    expect_length(na.omit(all_types), 18)
    expect_true(all(expected_types %in% all_types))
})

setwd(wd)
