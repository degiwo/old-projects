import pandas as pd
from sklearn.model_selection import train_test_split
import joblib

from logistic_regression.config import config

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
    return x_train, x_test, y_train, y_test

def save_pipeline(pipeline):
    save_path = config.PIPELINE_PATH / config.PIPELINE_NAME
    joblib.dump(pipeline, save_path)

def load_pipeline():
    pipeline_path = config.PIPELINE_PATH / config.PIPELINE_NAME
    return joblib.load(filename=pipeline_path)
