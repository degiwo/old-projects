"""Module to provide the CLI functionality"""

from pathlib import Path
from typing import List, Optional

import typer

from todoapp import __appname__, __version__
from todoapp.api import TodoAPI
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


@app.command()
def add(description: List[str] = typer.Argument(...)) -> None:
    """Add a new to-do with a DESCRIPTION"""
    todoapi = TodoAPI(DEFAULT_DB_FILE)
    todo, error = todoapi.add(description)
    typer.secho(
        f"""to-do: "{todo["Description"]}" was added """,
        fg=typer.colors.GREEN,
    )


@app.command(name="list")
def list_all() -> None:
    """List all todos"""
    todoapi = TodoAPI(DEFAULT_DB_FILE)
    todo_list = todoapi.get_todo_list()
    if len(todo_list) == 0:
        typer.secho(
            "There are no tasks in the to-do list yet",
            fg=typer.colors.RED,
        )
        raise typer.Exit()
    typer.secho("\nto-do list:\n", fg=typer.colors.BLUE)
    columns = ("ID ", " | Done ", " | Description")
    headers = "".join(columns)
    typer.secho(headers, fg=typer.colors.BLUE, bold=True)
    typer.secho("-" * len(headers), fg=typer.colors.BLUE)
    for id, todo in enumerate(todo_list, 1):
        desc, done = todo.values()
        typer.secho(
            f"{id} {' '  * (len(columns[0]) - len(str(id)))}"
            f"| {done} {' ' * (len(columns[1]) - len(str(done)) - 3)}"
            f"| {desc}",
            fg=typer.colors.BLUE,
        )
    typer.secho("-" * len(headers), fg=typer.colors.BLUE)
