from teambuilder.utils import get_all_pokemon


def test_get_all_pokemon():
    all_pokemon = get_all_pokemon()
    assert isinstance(all_pokemon, list)
    assert len(all_pokemon) > 0
    assert isinstance(all_pokemon[0], str)
    assert all_pokemon[2] == "venusaur"
