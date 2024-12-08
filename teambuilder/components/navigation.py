import dash
import dash_bootstrap_components as dbc
from dash import html


def horizontal_navigation():
    return html.Div(
        dbc.NavbarSimple(
            [
                dbc.NavItem(
                    dbc.NavLink(
                        page["name"],
                        href=page["path"],
                        active="exact",
                    )
                )
                for page in dash.page_registry.values()
            ],
            brand="Teambuilder",
            color="primary",
            dark=True,
            links_left=True,
        )
    )
