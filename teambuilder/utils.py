import asyncio

import aiohttp
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


def get_all_data_of_type(chosen_type: str) -> list[dict[str, str]]:
    """Returns the appropriate data for the table"""
    list_of_pokemon = get_all_pokemon_of_type(chosen_type)

    async def main():
        all_infos = []
        async with aiohttp.ClientSession() as session:
            for pokemon in list_of_pokemon:
                url = f"{URL_POKEAPI}/pokemon/{pokemon}"
                async with session.get(url) as response:
                    pkmn = await response.json()
                    stats_dict = {
                        x.get("stat").get("name"): x.get("base_stat")
                        for x in pkmn.get("stats")
                    }
                    all_infos.append({"name": pokemon} | stats_dict)
        return all_infos

    return asyncio.run(main())
