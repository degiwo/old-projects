"""First level layout of application"""

import dash
from dash import Dash, html

app = Dash(
    __name__,
    assets_folder="../assets",
    use_pages=True,
    # pages_folder="./pages",
)
app.layout = html.Div(
    [
        dash.page_container,
    ]
)
