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
        Simulate a football match between the two teams and update their scores.
        """
        team1_goals = random.randint(0, 5)
        team2_goals = random.randint(0, 5)

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

        winner = (team1_info.team.name if team1_info.score > team2_info.score else
                team2_info.team.name if team2_info.score > team1_info.score else
                "No team")

        result = f"{team1_info.team.name} {team1_info.score} - {team2_info.score} {team2_info.team.name}"
        
        # Log the match result
        logging.info(result)
        return result

if __name__ == "__main__":
    team1 = Team("Team A")
    team2 = Team("Team B")
    game = Game(team1, team2)

    game.simulate_match()
    result = game.get_match_result()
