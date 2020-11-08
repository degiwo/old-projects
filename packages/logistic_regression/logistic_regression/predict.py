import pandas as pd
import joblib

from logistic_regression.config import config

def make_prediction(X):
    pipeline_path = config.PIPELINE_PATH / config.PIPELINE_NAME
    _pipeline = joblib.load(filename=pipeline_path)
    results = _pipeline.predict(X)

    return results


if __name__ == '__main__':
    data = pd.read_csv(config.TEST_PATH / config.TEST_NAME)
    X = data.drop(config.TARGET, axis=1)
    y = data[config.TARGET]

    pred = make_prediction(X)
    print(pred)
