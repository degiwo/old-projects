import random

from teams import team1, team2
from actions import get_possession_after_pass, get_possession_after_shot, get_possession_after_dribbling
from player import get_target, get_opponent, get_team_in_possession, get_action

class Game:
    def __init__(self):
        self.team1 = team1
        self.team2 = team2

        rand = random.randint(0, 1)
        if rand == 0:
            self.player_in_possession = team1[0] # start with goalkeeper
        else:
            self.player_in_possession = team2[0]

        self.team_in_possession, self.team_in_defense = get_team_in_possession(self.player_in_possession, self.team1, self.team2)
    
    def make_action(self):
        action = get_action(self.player_in_possession, self.team_in_possession)
        if action == "pass":
            target = get_target(self.player_in_possession, self.team_in_possession)
            opponent = get_opponent(self.player_in_possession, self.team_in_possession, self.team_in_defense)
            self.make_pass(target, opponent)
        elif action == "dribble":
            opponent = get_opponent(self.player_in_possession, self.team_in_possession, self.team_in_defense)
            self.make_dribbling(opponent)
        else:
            self.make_shot()

    def make_pass(self, target, opponent):
        self.player_in_possession = get_possession_after_pass(self.player_in_possession, target, opponent)
        self.team_in_possession, self.team_in_defense = get_team_in_possession(self.player_in_possession, self.team1, self.team2)
    
    def make_shot(self):
        self.player_in_possession = get_possession_after_shot(self.player_in_possession, self.team_in_defense)
        self.team_in_possession, self.team_in_defense = get_team_in_possession(self.player_in_possession, self.team1, self.team2)
    
    def make_dribbling(self, opponent):
        self.player_in_possession = get_possession_after_dribbling(self.player_in_possession, opponent)
        self.team_in_possession, self.team_in_defense = get_team_in_possession(self.player_in_possession, self.team1, self.team2)

if __name__ == '__main__':
    game = Game()
    for i in range(500):
        game.make_action()
