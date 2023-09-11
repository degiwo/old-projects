import logging
import random
from team import TeamMasterData, TeamMatchInfo


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

        team1_score = max(0, round(random.gauss(0.5 + team1_strength + (team1_strength - team2_strength), 1.5)))
        team2_score = max(0, round(random.gauss(0.5 + team2_strength + (team2_strength - team1_strength), 1.5)))

        self.team1_match_info.score += team1_score
        self.team2_match_info.score += team2_score
        self._is_finished = True

    def get_match_result(self) -> dict:
        """
        Get the result of the match log it.

        Returns:
            dict: A dictionary describing the match result with all relevant team information.
        """
        if not self._is_finished:
            raise RuntimeError("Tried to get match result without simulation first. Please call simulate_match() first.")
        
        result = {
            "team": self.team1_match_info,
            "opponent": self.team2_match_info
        }

        logging.info(result)
        return result
