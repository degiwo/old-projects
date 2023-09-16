import random
from typing import Iterable

from match import Match, MatchResult, Outcome
from team import TeamMasterData


class League:
    def __init__(self, teams: Iterable[TeamMasterData]) -> None:
        """
        Initialize a football league with mulitple teams.

        Args:
            teams (Iterable): A Iterable of TeamMasterData objects.
        """
        self.teams = list(teams)
        self.match_results: list[MatchResult] = []

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

    def get_league_table(self):
        """
        Get the current league table.
        """
        league_table = {}

        for result in self.match_results:
            team = result.team.name
            goals = result.goals
            goals_conceded = result.goals_conceded
            outcome = result.outcome

            if team not in league_table:
                league_table[team] = {
                    "goals": 0,
                    "goals_conceded": 0,
                    "goals_difference": 0,
                    "wins": 0,
                    "draws": 0,
                    "losses": 0,
                    "points": 0
                }
            
            league_table[team]["goals"] += goals
            league_table[team]["goals_conceded"] += goals_conceded
            league_table[team]["goals_difference"] += (goals - goals_conceded)
            if outcome == Outcome.WIN:
                league_table[team]["wins"] += 1
                league_table[team]["points"] += 3
            elif outcome == Outcome.DRAW:
                league_table[team]["draws"] += 1
                league_table[team]["points"] += 1
            else:
                league_table[team]["losses"] += 1
        
        sorted_league_table = sorted(
            league_table.items(),
            key=lambda x: (x[1]["points"], x[1]["goals_difference"], x[1]["goals"]),
            reverse=True
        )

        return sorted_league_table
