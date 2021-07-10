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

get_types_defense_table <- function(pkmn_team) {
    # create table: rows = types, columns = pkmn
    if (is.reactivevalues(pkmn_team)) {
        pkmn_team <- reactiveValuesToList(pkmn_team)
    }
    list_mult <- lapply(pkmn_team, function(x) x[["defense"]])
    df <- Reduce(function(x, y) merge(x, y, by = "type"), list_mult)
    df$weak <- apply(df[, grep("multiplicator", names(df))], 1, function(x) sum(x > 1))
    df$resist <- apply(df[, grep("multiplicator", names(df))], 1, function(x) sum(x < 1 & x > 0))
    df$immune <- apply(df[, grep("multiplicator", names(df))], 1, function(x) sum(x == 0))
    
    # calculate coverage
    df$coverage <- df$weak * 2 - df$resist * 2 - df$immune * 4
    df$coverage <- ifelse(df$coverage > 0, "bad",
                          ifelse(df$coverage > 0 | df$resist > 0 | df$immune > 0, "good", "neutral"))
    return(df)
}

get_recommended_additions <- function(pkmn_team) {
    df_defense <- get_types_defense_table(pkmn_team)
    bad_types <- df_defense$type[df_defense$coverage == "bad"]
    df_off <- get_offense_type_effects()
    
    recommended_types <- c()
    for (i in seq(bad_types)) {
        resists <- unlist(df_off$resisted_by[df_off$name == bad_types[i]])
        # weight immunity by double
        immunes <- rep(unlist(df_off$immuned_by[df_off$name == bad_types[i]]), 2)
        new_recs <- c(resists, immunes)
        recommended_types <- append(recommended_types, new_recs)
    }
    return(names(sort(-table(recommended_types))))
}
