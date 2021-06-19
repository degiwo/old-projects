import pandas as pd

df_results = pd.read_csv("results.csv")
df_results.columns = ["player", "action", "target", "opponent", "result"]

df_results.groupby(["action", "result"]).size()
