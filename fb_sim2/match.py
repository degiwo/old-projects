from dataclasses import dataclass, field
from enum import Enum
import logging
import random

from team import TeamMasterData, TeamMatchInfo

class Outcome(Enum):
    """
    Enum to represent match outcomes (Win, Loss, Draw).
    """
    WIN = "Win"
    LOSS = "Loss"
    DRAW = "Draw"


@dataclass
class MatchResult:
    """
    A blueprint to represent all relevant information of a finished match.
    """
    team: TeamMasterData
    goals: int
    outcome: Outcome = field(init=False)  # Will be automatically calculated based on goals and goals_conceded
    goals_conceded: int
    opponent: TeamMasterData

    def __post_init__(self):
        if self.goals > self.goals_conceded:
            self.outcome = Outcome.WIN
        elif self.goals < self.goals_conceded:
            self.outcome = Outcome.LOSS
        else:
            self.outcome = Outcome.DRAW


class Match:
    def __init__(self, team1: TeamMasterData, team2: TeamMasterData) -> None:
        """
        Initialize a football match between two teams.

        Args:
            team1 (Team): The first team.
            team2 (Team): The second team.
        """
        self.team1_match_info = TeamMatchInfo(team1)
        self.team2_match_info = TeamMatchInfo(team2)
        self._is_finished: bool = False

    def simulate_match(self) -> None:
        """
        Simulate a football match between the two teams and update their scores based on their strengths.
        """
        if self._is_finished:
            raise RuntimeError("Match is already finished and a result exists.")
        team1_strength = self.team1_match_info.team.strength
        team2_strength = self.team2_match_info.team.strength

        team1_goals = max(0, round(random.gauss(0.5 + team1_strength + (team1_strength - team2_strength), 1.5)))
        team2_goals = max(0, round(random.gauss(0.5 + team2_strength + (team2_strength - team1_strength), 1.5)))

        self.team1_match_info.goals += team1_goals
        self.team2_match_info.goals += team2_goals
        self._is_finished = True

    def get_match_result(self) -> MatchResult:
        """
        Get the result of the match log it.

        Returns:
            MatchResult: A object describing the match result with all relevant team information.
        """
        if not self._is_finished:
            raise RuntimeError("Tried to get match result without simulation first. Please call simulate_match() first.")
        
        result = MatchResult(
            team=self.team1_match_info.team,
            goals=self.team1_match_info.goals,
            goals_conceded=self.team2_match_info.goals,
            opponent=self.team2_match_info.team
        )

        logging.info(result)
        return result
