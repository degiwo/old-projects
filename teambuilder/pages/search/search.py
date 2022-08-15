import dash
import dash_bootstrap_components as dbc
from dash import Input, Output, State, dash_table, dcc, html
from teambuilder.utils import (
    get_all_infos_of_pokemon,
    get_all_pokemon_of_type,
    get_all_types,
)

dash.register_page(
    __name__,
    path="/search",
    order=1,
)


def layout():
    return html.Div(
        [
            html.H1("Search"),
            dbc.Row(
                [
                    dbc.Col(
                        html.P("In this section you can filter Pokémon."),
                        width=3,
                    ),
                    dbc.Col(
                        dbc.Button(
                            "Open filters",
                            id="search-button-open-filters",
                            n_clicks=0,
                        ),
                        width=3,
                    ),
                ]
            ),
            dbc.Row(
                dash_table.DataTable(
                    [
                        # merge the two dictionaries
                        {"name": pokemon} | get_all_infos_of_pokemon(pokemon)
                        # due to performance issues only the first 5 entries
                        # TODO: make performance better
                        for pokemon in get_all_pokemon_of_type("normal")[:5]
                    ],
                    style_table={
                        "color": "black"
                    },  # otherwise it is displayed white in dark mode
                ),
            ),
            dbc.Offcanvas(
                [
                    "Type",
                    dcc.Dropdown(
                        get_all_types(),
                        multi=True,
                        style={
                            "color": "black"
                        },  # otherwise it is displayed white in dark mode
                        id="search-dropdown-chosen-types",
                    ),
                ],
                id="search-offcanvas-filters",
                title="Choose filters",
                is_open=False,
            ),
        ]
    )


@dash.callback(
    Output(
        component_id="search-offcanvas-filters",
        component_property="is_open",
    ),
    Input(
        component_id="search-button-open-filters",
        component_property="n_clicks",
    ),
    State(
        component_id="search-offcanvas-filters",
        component_property="is_open",
    ),
)
def toggle_offcanvas_filters(click_on_button: int, canvas_state: bool) -> bool:
    if click_on_button:
        return not canvas_state
    return canvas_state
