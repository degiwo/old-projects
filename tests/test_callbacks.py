import requests
from dash import Dash, html
from teambuilder.home.home_view import (
    store_pokemon_team,
    update_pokemon_sprite,
    update_pokemon_types_icons,
)


def test_store_pokemon_team():
    team = store_pokemon_team(["bulbasaur", "mew"])
    assert isinstance(team, dict)
    assert len(team) > 0
    assert team.get("0").get("name") == "bulbasaur"


def test_update_pokemon_sprite():
    pokemon_team = {
        "0": {"name": "bulbasaur", "types": ["grass", "poison"]},
        "1": {"name": "mew", "types": ["psychic"]},
        "2": {"name": None, "types": []},
    }
    sprite = update_pokemon_sprite(pokemon_team, {"index": 1})
    assert isinstance(sprite, str)
    assert sprite[-4:] == ".png"
    assert requests.get(sprite).ok


def test_update_pokemon_types_icons():
    # create empty app, so the function can be called
    app = Dash(__name__)
    app.layout = html.Div()
    pokemon_team = {
        "0": {"name": "bulbasaur", "types": ["grass", "poison"]},
        "1": {"name": "mew", "types": ["psychic"]},
        "2": {"name": None, "types": []},
    }
    icons = update_pokemon_types_icons(
        pokemon_team, {"type": "home-in-pokemon", "index": 0}
    )
    assert isinstance(icons, list)
    assert len(icons) == 2
    assert isinstance(icons[0], html.Img)
