from teambuilder.home.home_layout import create_home_layout


def test_home_layout():
    layout = create_home_layout()
    assert isinstance(layout, list)
    assert len(layout) > 0
