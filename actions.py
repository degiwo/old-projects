import random

def get_possession_after_pass(passer, target, opponent):
    result = random.choices(["Success", "Fail"], weights=[passer["pas"], 50])[0]
    print(passer["name"] + " passes to " + target["name"] + ": " + result)
    if result == "Success":
        return target
    else:
        return opponent

def get_possession_after_shot(shooter, team_in_defense):
    rand = random.randint(0, 10)
    if rand <= 2:
        result = "Goal"
        player_in_possession = team_in_defense[-1] # forward kick-off
    else:
        result = "Fail"
        player_in_possession = team_in_defense[0] # goalkeeper
    print(shooter['name'] + " shoots: " + result)
    return player_in_possession

def get_possession_after_dribbling(dribbler, opponent):
    rand = random.randint(0, 10)
    if rand <= 7:
        result = "Success"
    else:
        result = "Fail"
    print(dribbler["name"] + " dribbles against " + opponent["name"] + ": " + result)
    if result != "Success":
        return opponent
    else:
        return dribbler
