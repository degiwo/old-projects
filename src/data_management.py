import pandas_datareader as pdr
from datetime import datetime

# Request data via Yahoo public API
data_goog = pdr.get_data_yahoo("GOOG", end=datetime(2021, 6, 30))
data_amzn = pdr.get_data_yahoo("AMZN", end=datetime(2021, 6, 30))
data_fb = pdr.get_data_yahoo("FB", end=datetime(2021, 6, 30))
data_aapl = pdr.get_data_yahoo("AAPL", end=datetime(2021, 6, 30))

# Join data to 1 DataFrame
data_join = data_goog. \
    join(data_amzn, rsuffix="_amzn"). \
    join(data_fb, rsuffix="_fb"). \
    join(data_aapl, rsuffix="_aapl")

data_join.to_csv("data/stock_data.csv")
