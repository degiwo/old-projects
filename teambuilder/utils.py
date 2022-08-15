import requests

URL_POKEAPI = "https://pokeapi.co/api/v2/"


def get_all_types() -> list[str]:
    """Returns a list of all Pokémon types ['normal', 'fighting', ...]"""
    url = URL_POKEAPI + "type"
    types = [x.get("name") for x in requests.get(url).json().get("results")]
    return [x for x in types if x not in ("unknown", "shadow")]
