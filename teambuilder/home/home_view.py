"""Main script for the home module. Callbacks are defined here"""

from typing import Union

import dash
import requests
from dash import ALL, MATCH, Input, Output, State, html
from teambuilder.home.home_layout import create_home_layout


# === Layout definition ===
def home_view() -> html.Div:
    """Function to call in the application layout script.
    One reason why it get passed as a function (instead of an object) is that
    the asset folder works with dash.get_asset_url()."""
    return html.Div(create_home_layout())


# === Callback logic ===
@dash.callback(
    Output(
        component_id="home-store-pokemon-team",
        component_property="data",
    ),
    Input(
        component_id={"type": "home-in-pokemon", "index": ALL},
        component_property="value",
    ),
)
def store_pokemon_team(input: list[str]) -> dict[str, dict[str, Union[str, list[str]]]]:
    """Get all chosen Pokémon and store them in a dictionary
    Example: {'1': {'name': 'bulbasaur', 'types': ['grass', 'poison']},
    '2': {'name': 'mew', 'types': ['psychic']},
    '3': {'name': None, 'types': []}, ...}
    """
    current_pokemon_team = {}
    for (i, name) in enumerate(input):
        try:
            types_dict: dict = (
                requests.get(f"https://pokeapi.co/api/v2/pokemon/{name}")
                .json()
                .get("types")
            )
        except requests.JSONDecodeError:
            types_dict = {}
        types_list = [x.get("type").get("name") for x in types_dict]
        member = {"name": name, "types": types_list}
        current_pokemon_team.update({str(i): member})
    return current_pokemon_team


@dash.callback(
    Output(
        component_id={"type": "home-out-pokemon-sprite", "index": MATCH},
        component_property="src",
    ),
    Input(
        component_id="home-store-pokemon-team",
        component_property="data",
    ),
    State(
        component_id={"type": "home-in-pokemon", "index": MATCH},
        component_property="id",
    ),
)
def update_pokemon_sprite(
    pokemon_team: dict[str, dict[str, Union[str, list[str]]]],
    state: dict[str, Union[str, int]],
) -> str:
    """Get the URL to the sprite of the Pokémon.
    Update when home-store-pokemon-team get changed,
    lookup of index from home-in-pokemon."""
    # state is of form: {'type': 'home-in-pokemon', 'index': 0}
    pokemon_name = pokemon_team.get(str(state.get("index"))).get("name")
    try:
        output = (
            requests.get(f"https://pokeapi.co/api/v2/pokemon/{pokemon_name}")
            .json()
            .get("sprites")
            .get("front_default")
        )
    except requests.JSONDecodeError:
        output = (
            "https://upload.wikimedia.org/wikipedia/commons"
            "/thumb/5/55/Question_Mark.svg/288px-Question_Mark.svg.png"
        )
    print(output)
    return output


@dash.callback(
    Output(
        component_id={"type": "home-out-pokemon-types-icons", "index": MATCH},
        component_property="children",
    ),
    Input(
        component_id="home-store-pokemon-team",
        component_property="data",
    ),
    State(
        component_id={"type": "home-in-pokemon", "index": MATCH},
        component_property="id",
    ),
)
def update_pokemon_types_icons(
    pokemon_dict: dict[str, dict[str, Union[str, list[str]]]],
    state: dict[str, Union[str, int]],
) -> list[html.Img]:
    types_list = pokemon_dict.get(str(state.get("index"))).get("types")
    return [html.Img(src=dash.get_asset_url(f"{x}.png")) for x in types_list]
