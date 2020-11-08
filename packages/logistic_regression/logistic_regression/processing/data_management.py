import pandas as pd
from sklearn.model_selection import train_test_split
import joblib

from logistic_regression.config import config
from logistic_regression import __version__ as _version

import logging

_logger = logging.getLogger(__name__)

def read_train_data():
    data_path = config.DATA_PATH / config.DATA_NAME
    return pd.read_csv(data_path)

def read_test_data():
    data_path = config.TEST_PATH / config.TEST_NAME
    return pd.read_csv(data_path)

def get_X_y_from_data(data):
    X = data.drop(config.TARGET, axis=1)
    y = data[config.TARGET]
    return X, y

def get_train_test_split(X, y):
    x_train, x_test, y_train, y_test = train_test_split(
        X, y, test_size=config.TEST_SIZE_RATIO, random_state=0)
    _logger.info(f"number of training examples: {x_train.shape[0]}")
    return x_train, x_test, y_train, y_test

def save_pipeline(pipeline):
    save_file_name = f"{config.PIPELINE_NAME}_v{_version}.pkl"
    save_path = config.PIPELINE_PATH / save_file_name

    remove_old_pipelines(files_to_keep=save_file_name)
    joblib.dump(pipeline, save_path)
    _logger.info(f"saves pipeline: {save_file_name}")

def load_pipeline():
    load_file_name = f"{config.PIPELINE_NAME}_v{_version}.pkl"
    pipeline_path = config.PIPELINE_PATH / load_file_name
    return joblib.load(filename=pipeline_path)

def remove_old_pipelines(files_to_keep):
    for file in config.PIPELINE_PATH.iterdir():
        if file.name not in [files_to_keep, "__init__.py"]:
            file.unlink()
