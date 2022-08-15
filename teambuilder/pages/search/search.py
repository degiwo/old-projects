import dash
import dash_bootstrap_components as dbc
from dash import Input, Output, State, html

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
            dbc.Offcanvas(
                html.P("TEST"),
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
