import random

def get_possession_after_pass(passer, target, opponent):
    rand = random.randint(0, 10)
    if rand <= 7:
        result = "Success"
    else:
        result = "Fail"
    print(passer + " passes to " + target + ": " + result)
    if result == "Success":
        return target
    else:
        return opponent

def get_result_after_shot(shooter):
    rand = random.randint(0, 10)
    if rand <= 2:
        result = "Goal"
    else:
        result = "Fail"
    print(shooter + " shoots: " + result)

def get_possession_after_dribbling(dribbler, opponent):
    rand = random.randint(0, 10)
    if rand <= 7:
        result = "Success"
    else:
        result = "Fail"
    print(dribbler + " dribbles against " + opponent + ": " + result)
    if result != "Success":
        return  opponent
    else:
        return dribbler
