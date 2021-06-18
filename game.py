import random

from actions import get_possession_after_pass, get_result_after_shot, get_possession_after_dribbling

class Game:
    def __init__(self):
        self.team1 = ["A", "B", "C"]
        self.team2 = ["a", "b", "c"]
        self.player_in_possession = "A"
    
    def make_action(self):
        rand = random.randint(0, 10)
        if rand <= 6:
            if self.player_in_possession in self.team1:
                target = self.team1[random.randint(0, 2)]
                opponent = self.team2[random.randint(0, 2)]
            else:
                target = self.team2[random.randint(0, 2)]
                opponent = self.team1[random.randint(0, 2)]
            self.make_pass(target, opponent)
        elif rand <= 9:
            if self.player_in_possession in self.team1:
                opponent = self.team2[random.randint(0, 2)]
            else:
                opponent = self.team1[random.randint(0, 2)]
            self.make_dribbling(opponent)
        else:
            self.make_shot()

    def make_pass(self, target, opponent):
        self.player_in_possession = get_possession_after_pass(self.player_in_possession, target, opponent)
    
    def make_shot(self):
        get_result_after_shot(self.player_in_possession)
    
    def make_dribbling(self, opponent):
        self.player_in_possession = get_possession_after_dribbling(self.player_in_possession, opponent)

if __name__ == '__main__':
    game = Game()
    for i in range(10):
        game.make_action()
