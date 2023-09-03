import math

from random import choices
from typing import Iterable

from player import Player

class Match:
    def __init__(self, home: Iterable[Player], away: Iterable[Player]) -> None:
        self.home_team = home
        self.away_team = away

    def get_final_result(self):
        home_rating = sum(player.overall_rating for player in self.home_team)
        away_rating = sum(player.overall_rating for player in self.away_team)
        
        default_weights = [20, 35, 30, 10, 4, 1]
        if home_rating > away_rating:
            home_weights = [weight + 10 if index > 2 else weight for index, weight in enumerate(default_weights)]
            away_weights = default_weights
        elif home_rating < away_rating:
            home_weights = default_weights
            away_weights = [weight + 10 if index > 2 else weight for index, weight in enumerate(default_weights)]
            

        home_goals: int = choices([0, 1, 2, 3, 4, 5], home_weights)
        away_goals: int = choices([0, 1, 2, 3, 4, 5], away_weights)
        return home_goals, away_goals
