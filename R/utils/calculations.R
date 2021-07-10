get_defense_multiplicators <- function(type1, type2) {
    df_def <- get_defense_type_effects()
    df_mult <- data.frame(
        type = unique(df_def$name)
    )
    df_mult$type1 <- ifelse(
        df_mult$type %in% unlist(df_def$weaknesses[df_def$name == type1]), 2,
        ifelse(
            df_mult$type %in% unlist(df_def$resists[df_def$name == type1]), 0.5,
            ifelse(
                df_mult$type %in% unlist(df_def$immunes[df_def$name == type1]), 0, 1
            )
        )
    )
    df_mult$type2 <- ifelse(
        df_mult$type %in% unlist(df_def$weaknesses[df_def$name == type2]), 2,
        ifelse(
            df_mult$type %in% unlist(df_def$resists[df_def$name == type2]), 0.5,
            ifelse(
                df_mult$type %in% unlist(df_def$immunes[df_def$name == type2]), 0, 1
            )
        )
    )
    df_mult$multiplicator <- df_mult$type1 * df_mult$type2
    df_mult <- subset(df_mult, select = -c(type1, type2))
    return(df_mult)
}

get_recommended_additions <- function(pkmn_team) {
    return("Poison")
}
