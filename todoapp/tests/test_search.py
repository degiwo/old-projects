from dash import html
from teambuilder.pages.search.search import (
    layout,
    update_datatable_filtered_pokemon,
    update_store_filtered_pokemon,
)


def test_layout_returns_a_div():
    search_layout = layout()
    assert isinstance(search_layout, html.Div)


def testupdate_store_filtered_pokemon_returns_correct_pokemon():
    pokemon_and_ability = update_store_filtered_pokemon(
        chosen_types=["fire"], chosen_ability="speed-boost"
    )
    assert "list_of_filtered_pokemon" in pokemon_and_ability.keys()
    assert len(pokemon_and_ability.get("list_of_filtered_pokemon")) == 4
    assert "blaziken" in pokemon_and_ability.get("list_of_filtered_pokemon")
    assert "flareon" not in pokemon_and_ability.get("list_of_filtered_pokemon")

    pokemon_only = update_store_filtered_pokemon(
        chosen_types=["fire"], chosen_ability=None
    )
    assert "houndour" in pokemon_only.get("list_of_filtered_pokemon")
    assert "flareon" in pokemon_only.get("list_of_filtered_pokemon")
    assert "bulbasaur" not in pokemon_only.get("list_of_filtered_pokemon")

    ability_only = update_store_filtered_pokemon(
        chosen_types=None, chosen_ability="static"
    )
    assert "ampharos" in ability_only.get("list_of_filtered_pokemon")
    assert "emolga" in ability_only.get("list_of_filtered_pokemon")
    assert "blaziken" not in ability_only.get("list_of_filtered_pokemon")


def test_update_datatable_filtered_pokemon_returns_correct_data():
    input_dict = {"list_of_filtered_pokemon": ["bulbasaur", "mew"]}
    data, tooltips = update_datatable_filtered_pokemon(input_dict)

    assert isinstance(data, list)
    assert "sprite" in data[0].keys()
    assert "attack" in data[0].keys()
    assert data[0].get("name") == "bulbasaur"

    assert isinstance(tooltips, list)
    assert tooltips[0].get("name").get("type") == "markdown"
