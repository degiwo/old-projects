"""First level layout of application"""

from dash import Dash, html

app = Dash(__name__)
app.layout = html.Div([html.H1("Teambuilder")])
