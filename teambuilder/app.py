"""First level layout of application"""

import requests
from dash import ALL, MATCH, Dash, Input, Output, State, dcc, html


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
        html.Div(
            [
                html.Div(
                    [
                        html.Img(
                            id={
                                "type": "home-out-pokemon-sprite",
                                "index": i,
                            },
                            style={"height": "96px", "width": "96px"},
                        ),
                        html.Br(),
                        dcc.Dropdown(
                            get_all_pokemon(),
                            id={
                                "type": "home-in-pokemon",
                                "index": i,
                            },
                        ),
                    ]
                )
                for i in range(6)
            ]
        ),
        dcc.Store(id="home-store-pokemon-team"),
    ]
)


@app.callback(
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


@app.callback(
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
