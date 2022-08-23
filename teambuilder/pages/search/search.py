import dash
import dash_bootstrap_components as dbc
from dash import Input, Output, State, dash_table, dcc, html
from teambuilder.utils import (
    get_all_pokemon_names_of_types,
    get_all_types,
    get_data_of_pokemon,
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
                    id="search-datatable-filtered-pokemon",
                    hidden_columns=["sprite"],
                    sort_action="native",
                    style_cell={
                        "background": "#505050",
                        "textAlign": "left",
                    },
                    style_header={
                        "background": "#282828",
                    },
                    css=[
                        {
                            "selector": ".dash-table-tooltip",
                            "rule": "background-color: grey",
                        },
                        {
                            "selector": ".show-hide",
                            "rule": "display: none",
                        },  # otherwise a useless toggle button is shown
                        # because of hidden_columns
                    ],
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


@dash.callback(
    Output(
        component_id="search-datatable-filtered-pokemon",
        component_property="data",
    ),
    Output(
        component_id="search-datatable-filtered-pokemon",
        component_property="tooltip_data",
    ),
    Input(
        component_id="search-dropdown-chosen-types",
        component_property="value",
    ),
)
def update_datatable_filtered_pokemon(
    chosen_types: list[str],
) -> tuple[list[dict[str, str]], list[dict[str, dict[str, str]]]]:
    # TODO: tooltips after sorting table not correct
    pkmn_names_of_chosen_types = get_all_pokemon_names_of_types(chosen_types)
    data_of_pokemon = get_data_of_pokemon(pkmn_names_of_chosen_types)
    tooltips = [
        {
            "name": {
                "value": f"![]({pkmn.get('sprite')})",
                "type": "markdown",
            }
        }
        for pkmn in data_of_pokemon
    ]
    if pkmn_names_of_chosen_types:
        return data_of_pokemon, tooltips
    return [], []
