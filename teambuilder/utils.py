import requests

URL_POKEAPI = "https://pokeapi.co/api/v2/"


def get_all_types() -> list[str]:
    """Returns a list of all Pokémon types ['normal', 'fighting', ...]"""
    url = URL_POKEAPI + "type"
    types = [x.get("name") for x in requests.get(url).json().get("results")]
    return [x for x in types if x not in ("unknown", "shadow")]


def get_all_pokemon_of_type(chosen_type: str) -> list[str]:
    """Returns a list of all Pokémon names with the chosen type"""
    url = f"{URL_POKEAPI}/type/{chosen_type}"
    pokemon = requests.get(url).json().get("pokemon")
    return [x.get("pokemon").get("name") for x in pokemon]


def get_all_infos_of_pokemon(chosen_pokemon: str) -> dict[str, str]:
    """Returns a dict with additional information of the chosen pokemon"""
    url = f"{URL_POKEAPI}/pokemon/{chosen_pokemon}"
    stats = requests.get(url).json().get("stats")
    return {x.get("stat").get("name"): x.get("base_stat") for x in stats}
