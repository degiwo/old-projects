get_defense_multiplicators <- function(type1, type2, ability) {
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

    # consider ability
    ability_immunities <- get_ability_immunities()
    temp <- na.omit(ability_immunities[ability_immunities$ability == ability, ])
    if (nrow(temp) > 0) {
        df_mult$type1[df_mult$type %in% unlist(temp$immunes)] <- 0.0
        df_mult$type1[df_mult$type %in% unlist(temp$weakness)] <- 2.0 * df_mult$type1[df_mult$type %in% unlist(temp$weakness)]
        df_mult$type1[df_mult$type %in% unlist(temp$resists)] <- 0.5 * df_mult$type1[df_mult$type %in% unlist(temp$resists)]
    }
    
    df_mult$multiplicator <- df_mult$type1 * df_mult$type2
    df_mult <- subset(df_mult, select = -c(type1, type2))
    return(df_mult)
}

get_types_defense_table <- function(pkmn_team) {
    # create table: rows = types, columns = pkmn
    if (is.reactivevalues(pkmn_team)) {
        pkmn_team <- reactiveValuesToList(pkmn_team)
    }
    list_mult <- lapply(pkmn_team, function(x) {
        df_def <- x[["defense"]]
        
        # consider ability
        ability_immunities <- get_ability_immunities()
        temp <- ability_immunities[ability_immunities$ability == x[["ability"]], ]
        if (nrow(temp) > 0) {
            df_def[df_def$type == unlist(temp$immunes), 2] <- 0.00
        }
        
        return(df_def)
    })
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
    
    # recommended types -------------------------------------------------------
    df_off <- get_offense_type_effects()
    recommended_types <- c()
    for (i in seq(bad_types)) {
        resists <- rep(unlist(df_off$resisted_by[df_off$name == bad_types[i]]), 2)
        # weight immunity by 1.5
        immunes <- rep(unlist(df_off$immuned_by[df_off$name == bad_types[i]]), 3)
        new_recs <- c(resists, immunes)
        recommended_types <- append(recommended_types, new_recs)
    }
    # consider existing weaknesses, remove 1 entry
    for (i in seq(bad_types)) {
        weaks <- unlist(df_off$effective[df_off$name == bad_types[i]])
        for (j in seq(weaks)) {
            recommended_types[recommended_types %in% weaks[j]][1] <- NA
        }
    }
    

    # recommended abilities ---------------------------------------------------
    df_abs <- get_ability_immunities()
    recommended_abilities <- c()
    for (i in seq(bad_types)) {
        immunes <- rep(unlist(df_abs$ability[df_abs$immunes == bad_types[i]]), 3)
        recommended_abilities <- append(recommended_abilities, immunes)
    }

    return(table(c(recommended_types, recommended_abilities)))
}

get_recommended_pkmn <- function(recommended_additions, show_onlyrectypes) {
    df_pokedex <- get_pokedex()
    if (is.reactive(recommended_additions)) {
        recommended_additions <- recommended_additions()
    }
    ty_ab <- names(sort(-recommended_additions)) # types and abilities
    
    if (!show_onlyrectypes) {
        df_pkmn <- df_pokedex
    } else {
        list_pkmn <- list()
        for (i in seq(ty_ab)) {
            bool_type <- (
                df_pokedex$type1 == ty_ab[i] |
                    (!is.na(df_pokedex$type2) & df_pokedex$type2 == ty_ab[i])
            )
            bool_abilities <- (
                df_pokedex$abilities.0 == ty_ab[i] |
                    df_pokedex$abilities.1 == ty_ab[i] |
                    df_pokedex$abilities.S == ty_ab[i] |
                    df_pokedex$abilities.H == ty_ab[i]
            )
            temp <- df_pokedex[bool_type | bool_abilities, ]
            list_pkmn[[i]] <- temp
        }
        df_pkmn <- unique(do.call(rbind, list_pkmn))
        df_pkmn <- df_pkmn[!is.na(df_pkmn$name), ]
    }
    
    # prio for pkmn with more than one matching recommended type
    # recommended_additions is a table: higher the value => more resistances
    df_pkmn$prio_type <- apply(df_pkmn, 1, function(x) {
        sum(c(recommended_additions[x["type1"]], recommended_additions[x["type2"]]), na.rm = TRUE)
    })
    df_pkmn <- df_pkmn[order(df_pkmn$prio_type, df_pkmn$total, decreasing = TRUE), ]
    
    return(df_pkmn)
}
