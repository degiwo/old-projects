import random

class Game:
    def __init__(self):
        self.team1 = ["A", "B", "C"]
        self.team2 = ["a", "b", "c"]
        self.player_in_posession = "A"
    
    def make_action(self):
        rand = random.randint(0, 10)
        if rand <= 6:
            if self.player_in_posession in self.team1:
                target = self.team1[random.randint(0, 2)]
                opponent = self.team2[random.randint(0, 2)]
            else:
                target = self.team2[random.randint(0, 2)]
                opponent = self.team1[random.randint(0, 2)]
            self.make_pass(target, opponent)
        elif rand <= 9:
            if self.player_in_posession in self.team1:
                opponent = self.team2[random.randint(0, 2)]
            else:
                opponent = self.team1[random.randint(0, 2)]
            self.make_dribbling(opponent)
        else:
            self.make_shot()

    def make_pass(self, target, opponent):
        rand = random.randint(0, 10)
        if rand <= 7:
            result = "Success"
        else:
            result = "Fail"
        print(self.player_in_posession + " passes to " + target + ": " + result)
        if result == "Success":
            self.player_in_posession = target
        else:
            self.player_in_posession = opponent
    
    def make_shot(self):
        rand = random.randint(0, 10)
        if rand <= 2:
            result = "Goal"
        else:
            result = "Fail"
        print(self.player_in_posession + " shoots: " + result)
    
    def make_dribbling(self, opponent):
        rand = random.randint(0, 10)
        if rand <= 7:
            result = "Success"
        else:
            result = "Fail"
        print(self.player_in_posession + " dribbles against " + opponent + ": " + result)
        if result != "Success":
            self.player_in_posession = opponent

if __name__ == '__main__':
    game = Game()
    for i in range(10):
        game.make_action()
