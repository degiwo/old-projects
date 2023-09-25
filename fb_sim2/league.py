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
        self.league_table = {}

    def simulate_season(self) -> None:
        """
        Simulate a season in the league.
        """
        for i, team1 in enumerate(self.teams):
            for j, team2 in enumerate(self.teams):
                if i != j and j > i:  # Ensure teams are different and avoid duplicates
                    home_match = Match(team1, team2)
                    home_match.simulate_match()
                    self.match_results.append(home_match.get_match_result())

                    away_match = Match(team2, team1)
                    away_match.simulate_match()
                    self.match_results.append(away_match.get_match_result())

    def __add_match_result_to_league_table(self, match_result: MatchResult) -> None:
        """
        Helper function because we need to add the result for the home AND the away team.
        """
        team = match_result.team.name
        opponent = match_result.opponent.name
        goals = match_result.goals
        goals_conceded = match_result.goals_conceded
        outcome = match_result.outcome

        if team not in self.league_table:
            self.league_table[team] = {
                "goals": 0,
                "goals_conceded": 0,
                "goals_difference": 0,
                "wins": 0,
                "draws": 0,
                "losses": 0,
                "points": 0
            }
        
        if opponent not in self.league_table:
            self.league_table[opponent] = {
                "goals": 0,
                "goals_conceded": 0,
                "goals_difference": 0,
                "wins": 0,
                "draws": 0,
                "losses": 0,
                "points": 0
            }

        self.league_table[team]["goals"] += goals
        self.league_table[opponent]["goals"] += goals_conceded

        self.league_table[team]["goals_conceded"] += goals_conceded
        self.league_table[opponent]["goals_conceded"] += goals

        self.league_table[team]["goals_difference"] += (goals - goals_conceded)
        self.league_table[opponent]["goals_difference"] += (goals_conceded - goals)

        if outcome == Outcome.WIN:
            self.league_table[team]["wins"] += 1
            self.league_table[team]["points"] += 3
            self.league_table[opponent]["losses"] += 1
        elif outcome == Outcome.DRAW:
            self.league_table[team]["draws"] += 1
            self.league_table[team]["points"] += 1
            self.league_table[opponent]["draws"] += 1
            self.league_table[opponent]["points"] += 1
        else:
            self.league_table[team]["losses"] += 1
            self.league_table[opponent]["wins"] += 1
            self.league_table[opponent]["points"] += 3
        
        return self.league_table

    def get_league_table(self):
        """
        Get the current league table by evaluating the match results.
        """
        self.league_table = {}  # reset league table to avoid adding the same result multiple times
        for result in self.match_results:
            self.__add_match_result_to_league_table(result)
        
        sorted_league_table = sorted(
            self.league_table.items(),
            key=lambda x: (x[1]["points"], x[1]["goals_difference"], x[1]["goals"]),
            reverse=True
        )

        return sorted_league_table
