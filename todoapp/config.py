"""Module to store configuration"""

from pathlib import Path

import typer

from todoapp import __appname__

PATH_CONFIG_DIR = Path(typer.get_app_dir(__appname__))
