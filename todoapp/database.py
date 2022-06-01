"""Module to provide database functionality via JSON file"""

from pathlib import Path

DEFAULT_DB_FILE = Path.home().joinpath("." + Path.home().stem + "_todo.json")


def init_database(db_path: Path):
    """Create to-do database with empty list"""
    db_path.write_text("[]")
