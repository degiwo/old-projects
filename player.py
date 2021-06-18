import random

def get_target(player, target_list):
    possible_target_list = [t for t in target_list if t != player]
    return possible_target_list[random.randint(0, len(possible_target_list)-1)]

def get_opponent(player, opponent_list):
    return opponent_list[random.randint(0, 2)]

def get_team_in_possession(player_in_possession, team1, team2):
    if player_in_possession in team1:
        team_in_possession = team1
        team_in_defense = team2
    else:
        team_in_possession = team2
        team_in_defense = team1
    return team_in_possession, team_in_defense
