import dash
import dash_bootstrap_components as dbc
from dash import Input, Output, State, dash_table, dcc, html
from teambuilder.utils import (
    get_all_abilities,
    get_all_moves,
    get_all_pokemon_names_of_ability,
    get_all_pokemon_names_of_moves,
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
            html.Br(),
            dbc.Row(
                dash_table.DataTable(
                    id="search-datatable-filtered-pokemon",
                    columns=[
                        {"name": x, "id": x}
                        for x in [
                            "name",
                            "type1",
                            "type2",  # TODO: better solution to force column?
                            "ability1",
                            "ability2",
                            "ability3",  # TODO: same as type2
                            "hp",
                            "attack",
                            "defense",
                            "special-attack",
                            "special-defense",
                            "speed",
                        ]
                    ],
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
                    html.Br(),
                    "Ability",
                    dcc.Dropdown(
                        get_all_abilities(),
                        style={
                            "color": "black"
                        },  # otherwise it is displayed white in dark mode
                        id="search-dropdown-chosen-ability",
                    ),
                    html.Br(),
                    "Moves",
                    dcc.Dropdown(
                        get_all_moves(),
                        multi=True,
                        style={
                            "color": "black"
                        },  # otherwise it is displayed white in dark mode
                        id="search-dropdown-chosen-moves",
                    ),
                ],
                id="search-offcanvas-filters",
                title="Choose filters",
                is_open=False,
            ),
            dcc.Store(id="search-store-filtered-pokemon"),
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
        component_id="search-store-filtered-pokemon",
        component_property="data",
    ),
    Input(
        component_id="search-dropdown-chosen-types",
        component_property="value",
    ),
    Input(
        component_id="search-dropdown-chosen-ability",
        component_property="value",
    ),
    Input(
        component_id="search-dropdown-chosen-moves",
        component_property="value",
    ),
)
def update_store_filtered_pokemon(
    chosen_types: list[str], chosen_ability: str, chosen_moves: list[str]
) -> dict[str, list[str]]:
    filtered_pokemon = []
    pkmn_of_chosen_types = get_all_pokemon_names_of_types(chosen_types)
    pkmn_of_chosen_ability = get_all_pokemon_names_of_ability(chosen_ability)
    pkmn_of_chosen_moves = get_all_pokemon_names_of_moves(chosen_moves)
    # TODO: there must be a better solution...
    if chosen_ability and chosen_types and pkmn_of_chosen_moves:
        filtered_pokemon = set.intersection(
            *map(
                set,
                [
                    pkmn_of_chosen_types,
                    pkmn_of_chosen_ability,
                    pkmn_of_chosen_moves,
                ],
            )
        )
    elif chosen_ability and chosen_types:
        filtered_pokemon = set.intersection(
            *map(
                set,
                [pkmn_of_chosen_types, pkmn_of_chosen_ability],
            )
        )
    elif chosen_ability and pkmn_of_chosen_moves:
        filtered_pokemon = set.intersection(
            *map(
                set,
                [pkmn_of_chosen_ability, pkmn_of_chosen_moves],
            )
        )
    elif chosen_types and pkmn_of_chosen_moves:
        filtered_pokemon = set.intersection(
            *map(
                set,
                [pkmn_of_chosen_types, pkmn_of_chosen_moves],
            )
        )
    elif chosen_ability:
        filtered_pokemon = pkmn_of_chosen_ability
    elif chosen_types:
        filtered_pokemon = pkmn_of_chosen_types
    elif pkmn_of_chosen_moves:
        filtered_pokemon = pkmn_of_chosen_moves
    return {"list_of_filtered_pokemon": list(filtered_pokemon)}


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
        component_id="search-store-filtered-pokemon",
        component_property="data",
    ),
)
def update_datatable_filtered_pokemon(
    store_dict: dict[str, list[str]],
) -> tuple[list[dict[str, str]], list[dict[str, dict[str, str]]]]:
    # TODO: tooltips after sorting table not correct
    filtered_pokemon = store_dict.get("list_of_filtered_pokemon")
    data_of_pokemon = get_data_of_pokemon(filtered_pokemon)
    tooltips = [
        {
            "name": {
                "value": f"![]({pkmn.get('sprite')})",
                "type": "markdown",
            }
        }
        for pkmn in data_of_pokemon
    ]
    if filtered_pokemon:
        return data_of_pokemon, tooltips
    return [], []
