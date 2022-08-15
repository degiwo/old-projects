"""First level layout of application"""

import dash
from dash import Dash, html

app = Dash(
    __name__,
    assets_folder="../assets",
    use_pages=True,
)
app_server = app.server

app.layout = html.Div(
    [
        dash.page_container,
    ]
)
