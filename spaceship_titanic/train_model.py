# Execute this script to train the model

import joblib

import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import OneHotEncoder
from dagshub import DAGsHubLogger

from spaceship_titanic.config import (
    PATH_DATA_FOLDER,
    PATH_MODEL_FOLDER,
    PATH_LOGS_FOLDER,
    FILE_NAME_TRAIN_DATA,
    FILE_NAME_MODEL_PIPELINE,
    COLUMN_ONEHOT,
)
from spaceship_titanic.logger import logger


if __name__ == "__main__":
    logger.info("train_model.py script started")
    dagshub_logger = DAGsHubLogger(
        hparams_path=PATH_LOGS_FOLDER + "params.yml", should_log_metrics=False
    )

    train_data = pd.read_csv(PATH_DATA_FOLDER + FILE_NAME_TRAIN_DATA)
    X_train = train_data.iloc[:, :-1]
    y_train = train_data.iloc[:, -1]

    preprocessor = ColumnTransformer(
        [
            ("one-hot", OneHotEncoder(handle_unknown="ignore"), COLUMN_ONEHOT),
        ]
    )
    dagshub_logger.log_hyperparams(preprocess_1="OneHotEncoder")
    pipeline = Pipeline(
        [
            ("prep", preprocessor),
            ("model", RandomForestClassifier(random_state=123)),
        ]
    )
    dagshub_logger.log_hyperparams(model="Random Forest")
    pipeline.fit(X_train, y_train)
    logger.info("Model successfully trained")
    logger.debug(f"Training score: {pipeline.score(X_train, y_train)}")

    joblib.dump(pipeline, PATH_MODEL_FOLDER + FILE_NAME_MODEL_PIPELINE)
    dagshub_logger.save()
    dagshub_logger.close()
    logger.info("train_model.py script ended")
    logger.info("###########################################")
