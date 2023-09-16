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
    A blueprint to represent information of a football team during a match and starts naturally with 0 for every attribute.
    """
    team: TeamMasterData
    goals: int = 0
