"""Module to provide the CLI functionality"""

from pathlib import Path
from typing import Optional

import typer

from todoapp import __appname__, __version__
from todoapp.database import DEFAULT_DB_FILE, init_database

app = typer.Typer()


def _version_callback(value: bool) -> None:
    """Return app name and version"""
    if value:
        typer.echo(f"{__appname__} v{__version__}")
        raise typer.Exit()


@app.callback()
def main(
    version: Optional[bool] = typer.Option(
        None,
        "-v",
        "--version",
        help="Show the version of the application and exit.",
        callback=_version_callback,
        is_eager=True,
    )
) -> None:
    return


@app.command()
def init(
    db_path: str = typer.Option(
        str(DEFAULT_DB_FILE),
        "-db",
        "--db-path",
        prompt="to-do database location?",  # prompt appears
    )
) -> None:
    """Initialize the to-do database and echo the path"""
    init_database(Path(db_path))
    typer.secho(f"The to-do database is {db_path}", fg=typer.colors.GREEN)
