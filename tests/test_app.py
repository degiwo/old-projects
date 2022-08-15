from dash import html
from teambuilder.app import app


def test_app_layout_is_html_div():
    assert isinstance(app.layout, html.Div)
