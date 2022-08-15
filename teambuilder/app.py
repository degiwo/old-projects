import dash
import dash_bootstrap_components as dbc
from dash import Dash, html

app = Dash(
    __name__,
    use_pages=True,
    external_stylesheets=[dbc.themes.DARKLY],
    meta_tags=[
        {"name": "viewport", "content": "width=device-width, initial-scale=1"},
    ],
)
app_server = app.server

app.layout = html.Div(dash.page_container)

if __name__ == "__main__":
    app.run_server(debug=True)
