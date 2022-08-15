import dash
from dash import html

dash.register_page(
    __name__,
    path="/",
    order=0,
)


def layout():
    return html.Div(
        [
            html.H1("Teambuilder"),
        ]
    )
