import requests
from teambuilder.app import store_pokemon_team, update_pokemon_sprite


def test_store_pokemon_team():
    team = store_pokemon_team(["bulbasaur", "mew"], {})
    assert isinstance(team, dict)
    assert len(team) > 0
    assert team.get(0) == "bulbasaur"


def test_update_pokemon_sprite():
    sprite = update_pokemon_sprite("bulbasaur")
    assert isinstance(sprite, str)
    assert sprite[-4:] == ".png"
    assert requests.get(sprite).ok
