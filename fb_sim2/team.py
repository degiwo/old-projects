from dataclasses import dataclass


@dataclass
class TeamMasterData:
    """
    Represents a football team and its master data.
    """
    name: str
    strength: float

@dataclass
class TeamMatchInfo:
    """
    Represents information of a football team in a match and starts naturally with 0 for every attribute.
    """
    team: TeamMasterData
    score: int = 0
