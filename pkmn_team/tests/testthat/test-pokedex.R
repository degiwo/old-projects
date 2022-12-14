source("R/data/pokedex.R")

pokedex <- prepare_pokedex()

test_that("pokedex has the needed columns", {
    needed_cols <- c(
        "name", "id", "type", "type1", "type2",
        "base.HP", "base.Attack", "base.Sp. Defense", "total",
        "abilities", "abilities.0", "abilities.1", "abilities.H"
    )
    expect_true(all(needed_cols %in% names(pokedex)))
})

test_that("pokedex is a list with columns and rows", {
    expect_type(pokedex, "list")
    expect_gt(nrow(pokedex), 100)
    expect_gt(ncol(pokedex), 20)
})

test_that("pokedex has the correct type namings", {
    expected_types <- c("Normal", "Fire", "Water", "Grass", "Electric", "Bug",
                        "Poison", "Ground", "Fairy", "Psychic", "Fighting",
                        "Rock", "Ghost", "Ice", "Dragon", "Dark", "Steel", "Flying"
                        , "Bird" # Missingno
                        )
    expect_true(all(pokedex$type1 %in% expected_types))
    expect_true(all(na.omit(pokedex$type2) %in% expected_types))
})

test_that("stat columns are integer", {
    stat_columns <- c("base.HP", "base.Attack", "base.Defense",
                      "base.Sp. Attack", "base.Sp. Defense", "base.Speed")
    for (i in seq(stat_columns)) {
        expect_type(pokedex[[stat_columns[i]]], "integer")
    }
})

test_that("type column has the correct values", {
    expect_true(all(c("Grass,Poison", "Water", "Dragon,Flying") %in% pokedex$type))
})

test_that("abilities has correct values", {
    expect_true(all(c("Overgrow,Chlorophyll", "Blaze,Solar Power") %in% pokedex$abilities))
})
