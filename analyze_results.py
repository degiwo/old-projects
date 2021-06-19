import numpy as np
import pandas as pd

from teams import team1, team2

df_results = pd.read_csv("results.csv")
df_results.columns = ["player", "action", "target", "opponent", "result"]

team1_player_names = [t["name"] for t in team1]
df_results["team"] = np.where(df_results["player"].isin(team1_player_names), 1, 2)

df_results.groupby(["team", "action", "result"]).size()
 