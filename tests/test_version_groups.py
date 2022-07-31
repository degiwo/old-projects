from teambuilder.app import get_version_groups


def test_get_version_groups():
    version_groups = get_version_groups()
    assert isinstance(version_groups, list)
    assert len(version_groups) > 0
    assert isinstance(version_groups[0], str)
    assert "red-blue" in version_groups
