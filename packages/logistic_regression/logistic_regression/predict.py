import pandas as pd
import joblib

import config

def make_prediction(X):
    _pipeline = joblib.load(filename=config.PIPELINE_NAME)
    results = _pipeline.predict(X)

    return results


if __name__ == '__main__':
    data = pd.read_csv("test.csv")
    X = data.drop(config.TARGET, axis=1)
    y = data[config.TARGET]

    pred = make_prediction(X)
    print(pred)
