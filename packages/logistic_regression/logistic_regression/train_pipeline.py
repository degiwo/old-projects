import pandas as pd

from sklearn.model_selection import train_test_split
import joblib

from logistic_regression.config import config
import pipeline

def read_data():
    data_path = config.DATA_PATH / config.DATA_NAME
    return pd.read_csv(data_path)

def save_pipeline(pipeline):
    save_path = config.PIPELINE_PATH / config.PIPELINE_NAME
    joblib.dump(pipeline, save_path)

def run_model():
    data = read_data()
    X = data.drop(config.TARGET, axis=1)
    y = data[config.TARGET]

    x_train, x_test, y_train, y_test = train_test_split(
        X, y, test_size=config.TEST_SIZE_RATIO, random_state=0)

    pipeline.model_pipeline.fit(x_train, y_train)
    save_pipeline(pipeline.model_pipeline)


if __name__ == '__main__':
    run_model()
