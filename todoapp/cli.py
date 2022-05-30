"""Module to provide the CLI functionality"""

from typing import Optional

import typer

from todoapp import __appname__, __version__

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
