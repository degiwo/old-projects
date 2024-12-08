import dash
import dash_bootstrap_components as dbc
from teambuilder.components import horizontal_navigation

nav = horizontal_navigation()


def test_horizontal_navigation_is_html_div():
    assert isinstance(nav, dash.html.Div)


def test_horizontal_navigation_has_navitems():
    nav_props = nav.to_plotly_json().get("props")
    assert isinstance(nav_props.get("children").children[0], dbc.NavItem)
