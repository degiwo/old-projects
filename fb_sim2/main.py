import logging
import random
from dataclasses import dataclass

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(message)s')

@dataclass
class Team:
    """
    Represents a football team.
    """
    name: str
    strength: float

@dataclass
class TeamMatchStats:
    """
    Represents statistics for a football team in a match.
    """
    team: Team
    score: int = 0

class Game:
    def __init__(self, team1: Team, team2: Team) -> None:
        """
        Initialize a football game between two teams.

        Args:
            team1 (Team): The first team.
            team2 (Team): The second team.
        """
        self.team1_stats = TeamMatchStats(team1)
        self.team2_stats = TeamMatchStats(team2)

    def simulate_match(self) -> None:
        """
        Simulate a football match between the two teams and update their scores based on their strengths.
        """
        team1_strength = self.team1_stats.team.strength
        team2_strength = self.team2_stats.team.strength

        team1_goals = max(0, round(random.gauss(2 + team1_strength, 1)))
        team2_goals = max(0, round(random.gauss(2 + team2_strength, 1)))

        self.team1_stats.score += team1_goals
        self.team2_stats.score += team2_goals

    def get_match_result(self) -> str:
        """
        Get the result of the match as a string and log it.

        Returns:
            str: A string describing the match result.
        """
        team1_info = self.team1_stats
        team2_info = self.team2_stats

        result = f"{team1_info.team.name} {team1_info.score} - {team2_info.score} {team2_info.team.name}"
        
        # Log the match result
        logging.info(result)
        return result

if __name__ == "__main__":
    team1 = Team("Team A", strength=0.8)
    team2 = Team("Team B", strength=0.7)
    game = Game(team1, team2)

    game.simulate_match()
    result = game.get_match_result()
