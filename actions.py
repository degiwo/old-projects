import random
from logger import write_log

def get_possession_after_pass(passer, target, opponent):
    result = random.choices(["Success", "Fail"], weights=[passer["pas"], 30 + opponent["def"]*0.1])[0]
    write_log([passer["name"], "pass", target["name"], "", result])
    if result == "Success":
        return target
    else:
        return opponent

def get_possession_after_shot(shooter, team_in_defense):
    keeper_skill = team_in_defense[0]["def"]
    result = random.choices(["Goal", "Fail"], weights=[shooter["sho"], 50 + keeper_skill*0.2])[0]
    player_in_possession = team_in_defense[0] # goalkeeper
    write_log([shooter['name'], "shot", "", "", result])
    return player_in_possession

def get_possession_after_dribbling(dribbler, opponent):
    result = random.choices(["Success", "Fail"], weights=[dribbler["dri"], 30 + opponent["def"]*0.1])[0]
    write_log([dribbler["name"], "dribble", "", opponent["name"], result])
    if result != "Success":
        return opponent
    else:
        return dribbler
