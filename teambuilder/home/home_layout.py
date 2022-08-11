"""Layout of the home module"""

import dash
import requests
from dash import dcc, html
from teambuilder.utils import get_all_pokemon, get_all_types, get_version_groups


def create_home_layout():
    """Return a list of dash html components"""
    return [
        # === Title ===
        html.H1("Teambuilder"),
        # === Radiobuttons to choose version group ===
        html.Label("Choose your version group:"),
        dcc.RadioItems(get_version_groups(), id="home-in-version-group"),
        # === 6 Divs where you can choose a Pokémon ===
        # and the corresponding sprite and types gets displayed
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
                        html.Div(
                            id={
                                "type": "home-out-pokemon-types-icons",
                                "index": i,
                            },
                        ),
                    ]
                )
                for i in range(6)
            ]
        ),
        # === Show type weaknesses of the team ===
        html.Div(
            [html.Img(src=dash.get_asset_url(f"{x}.png")) for x in get_all_types()]
        ),
        # === Store the chosen Pokémon here to share between callbacks ===
        dcc.Store(id="home-store-pokemon-team"),
    ]
