from dash import dcc, html
from teambuilder.utils import get_all_pokemon, get_version_groups


def create_home_layout():
    return [
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
