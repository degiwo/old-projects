import asyncio

import aiohttp
import requests

URL_POKEAPI = "https://pokeapi.co/api/v2/"


def get_all_types() -> list[str]:
    """Returns a list of all Pokémon types ['normal', 'fighting', ...]"""
    url = URL_POKEAPI + "type"
    types = [x.get("name") for x in requests.get(url).json().get("results")]
    return [x for x in types if x not in ("unknown", "shadow")]


def get_all_pokemon_names_of_types(chosen_types: list[str]) -> list[str]:
    """Returns a list of all Pokémon names with the chosen types"""
    if chosen_types:
        pokemon_of_types = []  # list of list of pokemon names for each type
        for type in chosen_types:
            resp = requests.get(f"{URL_POKEAPI}/type/{type}").json()
            pkmn = [x.get("pokemon").get("name") for x in resp.get("pokemon")]
            pokemon_of_types.append(pkmn)

        return set.intersection(*map(set, pokemon_of_types))
    return []


async def get_infos_of_pokemon(
    session: aiohttp.ClientSession, chosen_pokemon: str
) -> dict[str, str]:
    """Function to asynchronously get additional information of Pokémon"""
    url = f"{URL_POKEAPI}/pokemon/{chosen_pokemon}"
    async with session.get(url) as response:
        pkmn = await response.json()
        stats_dict = {
            stat.get("stat").get("name"): stat.get("base_stat")
            for stat in pkmn.get("stats")
        }
        return {"name": chosen_pokemon} | stats_dict  # merge two dictionaries


def get_data_of_pokemon(list_of_pokemon: list[str]) -> list[dict[str, str]]:
    """Returns the appropriate data for the table.
    This is done via asynchronous tasks which are gathered at the end."""

    async def main() -> list[dict[str, str]]:
        list_of_all_pokemon_data = []
        async with aiohttp.ClientSession() as session:
            async_tasks = []
            for pkmn in list_of_pokemon:
                async_tasks.append(
                    asyncio.ensure_future(get_infos_of_pokemon(session, pkmn))
                )
            list_of_all_pokemon_data = await asyncio.gather(*async_tasks)
        return list_of_all_pokemon_data

    return asyncio.run(main())
