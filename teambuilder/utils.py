import asyncio

import aiohttp
import requests

URL_POKEAPI = "https://pokeapi.co/api/v2/"


def get_all_types() -> list[str]:
    """Returns a list of all Pokémon types ['normal', 'fighting', ...]"""
    url = URL_POKEAPI + "type"
    types = [x.get("name") for x in requests.get(url).json().get("results")]
    return [x for x in types if x not in ("unknown", "shadow")]


def get_all_abilities() -> list[str]:
    """Returns a list of all Pokémon abilities ['stench', 'drizzle', ...]"""
    url = URL_POKEAPI + "ability?limit=1000"  # NOTE: parameter limit
    return [x.get("name") for x in requests.get(url).json().get("results")]


def get_all_moves() -> list[str]:
    """Returns a list of all Pokémon moves ['pound', 'karate-chop', ...]"""
    url = URL_POKEAPI + "move?limit=10000"  # NOTE: parameter limit
    return [x.get("name") for x in requests.get(url).json().get("results")]


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


def get_all_pokemon_names_of_ability(chosen_ability: str) -> list[str]:
    """Return a list of all Pokémon names with the chosen ability"""
    if chosen_ability:
        resp = requests.get(f"{URL_POKEAPI}/ability/{chosen_ability}").json()
        pkmn = [x.get("pokemon").get("name") for x in resp.get("pokemon")]
        return pkmn
    return []


def get_all_pokemon_names_of_moves(chosen_moves: list[str]) -> list[str]:
    """Returns a list of all Pokémon names with the chosen moves"""
    if chosen_moves:
        pokemon_of_moves = []  # list of list of pokemon names for each move
        for move in chosen_moves:
            resp = requests.get(f"{URL_POKEAPI}/move/{move}").json()
            pkmn = [x.get("name") for x in resp.get("learned_by_pokemon")]
            pokemon_of_moves.append(pkmn)

        return set.intersection(*map(set, pokemon_of_moves))
    return []


async def get_data_from_pokeapi(
    session: aiohttp.ClientSession, chosen_pokemon: str
) -> dict[str, str]:
    """Function to asynchronously get additional information of Pokémon.
    This should be the only place where you execute a GET to the pokemon route.
    """
    url = f"{URL_POKEAPI}/pokemon/{chosen_pokemon}"
    async with session.get(url) as response:
        pkmn = await response.json()

        sprite_dict = {"sprite": pkmn.get("sprites").get("front_default")}
        stats_dict = {
            stat.get("stat").get("name"): stat.get("base_stat")
            for stat in pkmn.get("stats")
        }
        types_dict = {
            f"type{pkmn_type.get('slot')}": pkmn_type.get("type").get("name")
            for pkmn_type in pkmn.get("types")
        }
        abilities_dict = {
            f"ability{ability.get('slot')}": ability.get("ability").get("name")
            for ability in pkmn.get("abilities")
        }

        # return merged dictionaries
        return (
            {"name": chosen_pokemon}
            | sprite_dict
            | types_dict
            | abilities_dict
            | stats_dict
        )


def get_data_of_pokemon(list_of_pokemon: list[str]) -> list[dict[str, str]]:
    """Returns the appropriate data for the table.
    This is done via asynchronous tasks which are gathered at the end."""

    async def main() -> list[dict[str, str]]:
        list_of_all_pokemon_data = []
        async with aiohttp.ClientSession() as session:
            async_tasks = []
            for pkmn in list_of_pokemon:
                async_tasks.append(
                    asyncio.ensure_future(get_data_from_pokeapi(session, pkmn))
                )
            list_of_all_pokemon_data = await asyncio.gather(*async_tasks)
        return list_of_all_pokemon_data

    return asyncio.run(main())


def get_text_of_ability(ability: str) -> str:
    """Return the short description text of a ability."""
    # TODO: use async to make faster
    if ability:
        url = f"{URL_POKEAPI}/ability/{ability}"
        resp = requests.get(url).json().get("effect_entries")
        return " ".join(
            [
                entry.get("short_effect")
                for entry in resp
                if entry.get("language").get("name") == "en"
            ]
        )
    return ""
