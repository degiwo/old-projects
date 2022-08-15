from json import JSONDecodeError

import dash
import requests
from dash import Input, Output, dcc, html

dash.register_page(__name__, path="/search")


def get_all_types():
    types = [
        item.get("name")
        for item in requests.get("https://pokeapi.co/api/v2/type").json().get("results")
        if item.get("name") not in ["unknown", "shadow"]
    ]
    return types


def layout():
    return html.Div(
        [
            html.H1("Search"),
            dcc.Dropdown(
                get_all_types(),
                id="search-input-type",
            ),
            dcc.Store(id="search-store-filtered-pokemon-list"),
        ]
    )


@dash.callback(
    Output("search-store-filtered-pokemon-list", "data"),
    Input("search-input-type", "value"),
)
def update_filtered_pokemon_list_by_type(input_type):
    try:
        pokemon_list = {
            x.get("pokemon").get("name"): 1
            for x in requests.get(f"https://pokeapi.co/api/v2/type/{input_type}")
            .json()
            .get("pokemon")
        }
    except JSONDecodeError:
        pokemon_list = {}
    print(pokemon_list)
    return pokemon_list
