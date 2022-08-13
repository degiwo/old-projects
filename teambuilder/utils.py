import requests


def get_version_groups():
    version_groups = [
        x.get("name")
        for x in requests.get("https://pokeapi.co/api/v2/version-group")
        .json()
        .get("results")
    ]
    return version_groups


def get_all_pokemon():
    all_pokemon = [
        x.get("name")
        for x in requests.get("https://pokeapi.co/api/v2/pokemon?limit=100000")
        .json()
        .get("results")
    ]
    return all_pokemon
