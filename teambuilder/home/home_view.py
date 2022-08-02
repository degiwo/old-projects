"""Main script for the home module. Callbacks are defined here"""

import dash
import requests
from dash import ALL, MATCH, Input, Output, State, html
from teambuilder.home.home_layout import create_home_layout

# === Layout definition ===
home_layout = html.Div(create_home_layout())


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
    State(
        component_id="home-store-pokemon-team",
        component_property="data",
    ),
)
def store_pokemon_team(
    input_pokemon: list[str], current_pokemon_team: dict[int, str]
) -> dict[int, str]:
    """Get all chosen Pokémon and store them in a dictionary
    Example: {1: "bulbasaur", 2: "mew", 3: None, 4: None, 5: None, 6: None}
    """
    # TODO: State is currently useless
    current_pokemon_team = {i: name for (i, name) in enumerate(input_pokemon)}
    return current_pokemon_team


@dash.callback(
    Output(
        component_id={"type": "home-out-pokemon-sprite", "index": MATCH},
        component_property="src",
    ),
    Input(
        component_id={"type": "home-in-pokemon", "index": MATCH},
        component_property="value",
    ),
)
def update_pokemon_sprite(pokemon_name: str) -> str:
    """Get the URL to the sprite of the Pokémon"""
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
    return output


@dash.callback(
    Output(
        component_id={"type": "home-out-pokemon-types", "index": MATCH},
        component_property="children",
    ),
    Input(
        component_id={"type": "home-in-pokemon", "index": MATCH},
        component_property="value",
    ),
)
def get_pokemon_types(pokemon_name: str) -> str:
    """Get the types of the chosen Pokémon as a string.
    Dual-types will return something like 'normal flying'"""
    try:
        types_list = (
            requests.get(f"https://pokeapi.co/api/v2/pokemon/{pokemon_name}")
            .json()
            .get("types")
        )
    except requests.JSONDecodeError:
        types_list = []
    types = " ".join([x.get("type").get("name") for x in types_list])
    return types
