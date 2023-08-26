from player import Player
from random import choices

class Match:
    def __init__(self, home: list[Player], away: list[Player]) -> None:
        self.home = home
        self.away = away

    def get_final_result(self):
        goals_home: int = choices([0, 1, 2, 3, 4, 5], [0.25, 0.3, 0.25, 0.15, 0.05, 0.05])
        goals_away: int = choices([0, 1, 2, 3, 4, 5], [0.25, 0.3, 0.25, 0.15, 0.05, 0.05])
        return goals_home, goals_away
