"""First level layout of application"""

from dash import Dash

from teambuilder.home.home_view import home_layout

app = Dash(__name__)
app.layout = home_layout
