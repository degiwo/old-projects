"""First level layout of application"""

import requests
from dash import Dash, dcc, html


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
    ]
)
