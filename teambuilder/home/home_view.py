import dash
import requests
from dash import ALL, MATCH, Input, Output, State, html
from teambuilder.home.home_layout import create_home_layout

home_layout = html.Div(create_home_layout())


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
def store_pokemon_team(input_pokemon, current_pokemon_team):
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
def update_pokemon_sprite(input_name):
    try:
        output = (
            requests.get(f"https://pokeapi.co/api/v2/pokemon/{input_name}")
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
