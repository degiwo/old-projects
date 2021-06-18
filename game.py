import random

from actions import get_possession_after_pass, get_result_after_shot, get_possession_after_dribbling
from player import get_target, get_opponent, get_team_in_possession

class Game:
    def __init__(self):
        self.team1 = ["A", "B", "C"]
        self.team2 = ["a", "b", "c"]
        self.player_in_possession = "A"

        self.team_in_possession = self.team1
        self.team_in_defense = self.team2
    
    def make_action(self):
        rand = random.randint(0, 10)
        if rand <= 6:
            target = get_target(self.player_in_possession, self.team_in_possession)
            opponent = get_opponent(self.player_in_possession, self.team_in_defense)
            self.make_pass(target, opponent)
        elif rand <= 9:
            opponent = get_opponent(self.player_in_possession, self.team_in_defense)
            self.make_dribbling(opponent)
        else:
            self.make_shot()

    def make_pass(self, target, opponent):
        self.player_in_possession = get_possession_after_pass(self.player_in_possession, target, opponent)
        self.team_in_possession, self.team_in_defense = get_team_in_possession(self.player_in_possession, self.team1, self.team2)
    
    def make_shot(self):
        get_result_after_shot(self.player_in_possession)
        if self.player_in_possession in self.team1:
            self.player_in_possession = self.team2[random.randint(0, 2)]
        else:
            self.player_in_possession = self.team1[random.randint(0, 2)]
        self.team_in_possession, self.team_in_defense = get_team_in_possession(self.player_in_possession, self.team1, self.team2)
    
    def make_dribbling(self, opponent):
        self.player_in_possession = get_possession_after_dribbling(self.player_in_possession, opponent)
        self.team_in_possession, self.team_in_defense = get_team_in_possession(self.player_in_possession, self.team1, self.team2)

if __name__ == '__main__':
    game = Game()
    for i in range(20):
        game.make_action()
