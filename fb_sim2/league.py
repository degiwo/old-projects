
import random
from typing import Iterable

from match import Match
from team import TeamMasterData


class League:
    def __init__(self, teams: Iterable[TeamMasterData]) -> None:
        """
        Initialize a football league with mulitple teams.

        Args:
            teams (Iterable): A Iterable of TeamMasterData objects.
        """
        self.teams = list(teams)
        self.match_results: list[dict] = []

    def simulate_season(self) -> None:
        """
        Simulate a season in the league.
        """
        for _ in range(20):
            team1, team2 = random.sample(self.teams, 2)
            game = Match(team1, team2)

            game.simulate_match()
            result = game.get_match_result()
            self.match_results.append(result)
