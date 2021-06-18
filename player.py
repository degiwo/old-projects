import random

def get_target(player, target_list):
    possible_target_list = [t for t in target_list if t != player]
    target_index = min(9, max(0, round(target_list.index(player) + random.normalvariate(0, 2))))
    return possible_target_list[target_index]

def get_opponent(player, team_list, opponent_list):
    possible_opponent_list = opponent_list[1:]
    opponent_index = min(9, max(0, round(team_list.index(player) + random.normalvariate(0, 2))))
    return possible_opponent_list[-opponent_index]

def get_team_in_possession(player_in_possession, team1, team2):
    if player_in_possession in team1:
        team_in_possession = team1
        team_in_defense = team2
    else:
        team_in_possession = team2
        team_in_defense = team1
    return team_in_possession, team_in_defense
