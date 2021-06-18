import random

def get_target(player, target_list):
    possible_target_list = [t for t in target_list if t != player]
    return possible_target_list[random.randint(0, len(possible_target_list)-1)]

def get_opponent(player, opponent_list):
    return opponent_list[random.randint(0, 2)]
