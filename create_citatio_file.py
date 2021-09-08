import pandas as pd
df = pd.read_csv('Citations.csv',header=None, delimiter=r"\s+")
df.to_csv ('Citations_comma.csv', index = False, header=False)