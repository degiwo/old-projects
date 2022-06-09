"""Module to provide database functionality via JSON file"""
import json
from pathlib import Path
from typing import Any, Dict, List, NamedTuple

DEFAULT_DB_FILE = Path.home().joinpath("." + Path.home().stem + "_todo.json")


def init_database(db_path: Path):
    """Create to-do database with empty list"""
    db_path.write_text("[]")


class DBResponse(NamedTuple):
    """Class send data to and retrieve data from the to-do database"""

    todo_list: List[Dict[str, Any]]
    error: str


class DatabaseHandler:
    """Class to read and write data to the to-do database"""

    def __init__(self, db_path: Path) -> None:
        self.db_path = db_path

    def read_todos(self) -> DBResponse:
        with self.db_path.open("r") as db:
            return DBResponse(json.load(db), "SUCCESS")

    def write_todos(self, todo_list: List[Dict[str, Any]]) -> DBResponse:
        with self.db_path.open("w") as db:
            json.dump(todo_list, db, indent=4)
        return DBResponse(todo_list, "SUCCESS")
