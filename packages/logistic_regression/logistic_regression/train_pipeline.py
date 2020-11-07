import pandas as pd

from sklearn.model_selection import train_test_split
import joblib

import config
import pipeline

def run_training():
    data = pd.read_csv(config.DATA_FILE_PATH)
    
    X = data.drop(config.TARGET, axis=1)
    y = data[config.TARGET]

    x_train, x_test, y_train, y_test = train_test_split(
        X, y, test_size=config.TEST_SIZE_RATIO, random_state=0)

    pipeline.model_pipeline.fit(x_train, y_train)
    joblib.dump(pipeline.model_pipeline, config.PIPELINE_NAME)

if __name__ == '__main__':
    run_training()
