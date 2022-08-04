"""First level layout of application"""

from dash import Dash

from teambuilder.home.home_view import home_view

app = Dash(__name__, assets_folder="../assets")
app.layout = home_view()
