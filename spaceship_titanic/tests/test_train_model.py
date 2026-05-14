import joblib

import pandas as pd
from sklearn.pipeline import Pipeline

from spaceship_titanic.config import (
    PATH_MODEL_FOLDER,
    PATH_DATA_FOLDER,
    FILE_NAME_MODEL_PIPELINE,
    FILE_NAME_EVALUATION_DATA,
)


def test_model_can_be_loaded():
    model = joblib.load(PATH_MODEL_FOLDER + FILE_NAME_MODEL_PIPELINE)
    assert isinstance(model, Pipeline)


def test_model_can_predict_data():
    model = joblib.load(PATH_MODEL_FOLDER + FILE_NAME_MODEL_PIPELINE)
    data = pd.read_csv(PATH_DATA_FOLDER + FILE_NAME_EVALUATION_DATA)
    pred = model.predict(data)
    assert len(pred) > 0
