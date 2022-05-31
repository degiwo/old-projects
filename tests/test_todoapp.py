"""Test Typer application"""
from typer.testing import CliRunner

from todoapp import __appname__, __version__, cli

runner = CliRunner()


def test_version():
    assert __version__ == "0.1.0"


def test_version_via_cli():
    result = runner.invoke(cli.app, ["--version"])
    assert result.exit_code == 0
    assert f"{__appname__} v{__version__}\n" in result.stdout
