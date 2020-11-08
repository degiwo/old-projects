import pandas as pd

from logistic_regression.predict import make_prediction
from logistic_regression.config import config

def test_make_prediction():
    data = pd.read_csv(config.TEST_PATH / config.TEST_NAME)[0:1]
    X = data.drop(config.TARGET, axis=1)
    y = data[config.TARGET]

    result = make_prediction(X)

    assert result is not None
