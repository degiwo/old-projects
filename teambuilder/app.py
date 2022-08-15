from dash import Dash, html

app = Dash(__name__)
app_server = app.server

app.layout = html.Div(html.H1("Teambuilder"))

if __name__ == "__main__":
    app.run_server(debug=True)
