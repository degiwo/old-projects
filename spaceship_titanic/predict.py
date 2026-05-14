# Run this script to predict new data

import joblib
from numpy import ndarray

import pandas as pd

from spaceship_titanic.config import (
    PATH_MODEL_FOLDER,
    FILE_NAME_MODEL_PIPELINE,
    FILE_NAME_EVALUATION_DATA,
    PATH_DATA_FOLDER,
)


def get_predictions(data: pd.DataFrame) -> ndarray:
    pipeline = joblib.load(PATH_MODEL_FOLDER + FILE_NAME_MODEL_PIPELINE)
    return pipeline.predict(data)


if __name__ == "__main__":
    df = pd.read_csv(PATH_DATA_FOLDER + FILE_NAME_EVALUATION_DATA)
    pred = get_predictions(df)
    print(pred)
