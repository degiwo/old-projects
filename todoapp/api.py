"""Module to connect the CLI with the database"""

from pathlib import Path
from typing import Any, Dict, NamedTuple

from todoapp.database import DatabaseHandler


class CurrentToDo(NamedTuple):
    """Class to hold the information of the current to-do"""

    todo: Dict[str, Any]
    error: str


class TodoAPI:
    """Class to connect DatabaseHandler logic with applications CLI"""

    def __init__(self, db_path: Path) -> None:
        self._db_handler = DatabaseHandler(db_path)
