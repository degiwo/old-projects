"""First level layout of application"""

import requests
from dash import Dash, Input, Output, dcc, html


def get_version_groups():
    version_groups = [
        x.get("name")
        for x in requests.get("https://pokeapi.co/api/v2/version-group")
        .json()
        .get("results")
    ]
    return version_groups


def get_all_pokemon():
    all_pokemon = [
        x.get("name")
        for x in requests.get("https://pokeapi.co/api/v2/pokemon?limit=100000")
        .json()
        .get("results")
    ]
    return all_pokemon


app = Dash(__name__)
app.layout = html.Div(
    [
        html.H1("Teambuilder"),
        html.Label("Choose your version group:"),
        dcc.RadioItems(get_version_groups(), id="home-in-version-group"),
        html.Br(),
        dcc.Dropdown(get_all_pokemon(), id="home-in-pokemon"),
        html.Br(),
        html.Img(id="home-out-pokemon-sprite"),
        dcc.Store(id="home-store-pokemon-team"),
    ]
)


@app.callback(
    Output(component_id="home-store-pokemon-team", component_property="data"),
    Input(component_id="home-in-pokemon", component_property="value"),
)
def store_pokemon_team(input_name):
    pokemon_team = {"1": input_name}
    return pokemon_team


@app.callback(
    Output(component_id="home-out-pokemon-sprite", component_property="src"),
    Input(component_id="home-store-pokemon-team", component_property="data"),
)
def update_pokemon_sprite(pokemon_team):
    input_name = pokemon_team.get("1")
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
