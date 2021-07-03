defense_type_effects <- get_defense_type_effects()

get_weaknesses <- function(type1, type2) {
    weak1 <- unlist(defense_type_effects$weaknesses[defense_type_effects$name == type1])
    weak2 <- unlist(defense_type_effects$weaknesses[defense_type_effects$name == type2])
    immune1 <- unlist(defense_type_effects$immunes[defense_type_effects$name == type1])
    immune2 <- unlist(defense_type_effects$immunes[defense_type_effects$name == type2])
    resist1 <- unlist(defense_type_effects$resists[defense_type_effects$name == type1])
    resist2 <- unlist(defense_type_effects$resists[defense_type_effects$name == type2])

    weak_types <- setdiff(c(weak1, weak2), c(immune1, immune2, resist1, resist2))
    return(weak_types)
}

get_resistances <- function(type1, type2) {
    weak1 <- unlist(defense_type_effects$weaknesses[defense_type_effects$name == type1])
    weak2 <- unlist(defense_type_effects$weaknesses[defense_type_effects$name == type2])
    resist1 <- unlist(defense_type_effects$resists[defense_type_effects$name == type1])
    resist2 <- unlist(defense_type_effects$resists[defense_type_effects$name == type2])

    resist_types <- setdiff(c(resist1, resist2), c(weak1, weak2))
    return(resist_types)
}

get_immunities <- function(type1, type2) {
    immune1 <- unlist(defense_type_effects$immunes[defense_type_effects$name == type1])
    immune2 <- unlist(defense_type_effects$immunes[defense_type_effects$name == type2])

    immune_types <- c(immune1, immune2)
    return(immune_types)
}
