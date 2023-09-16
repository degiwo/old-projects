import logging
import random

from league import League
from team import TeamMasterData

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(message)s")


if __name__ == "__main__":
    team1 = TeamMasterData("Team A", strength=random.random())
    team2 = TeamMasterData("Team B", strength=random.random())
    team3 = TeamMasterData("Team C", strength=random.random())
    league = League([team1, team2, team3])
    league.simulate_season()
    print(league.get_league_table())
