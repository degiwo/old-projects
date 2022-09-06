"""
tox runs this script which resembles the main file.
"""

import pathlib
import joblib
import pandas as pd
from sklearn.model_selection import train_test_split

from pipeline import price_pipe


DIR_ROOT_PACKAGE = pathlib.Path(__file__).resolve().parent
DIR_TRAINED_MODEL = DIR_ROOT_PACKAGE / "trained_models"
DIR_DATASET = DIR_ROOT_PACKAGE / "datasets"


def save_pipeline(pipeline_to_persist) -> None:
    """Persist the pipeline."""
    save_file_name = "regression_model.pkl"
    save_path = DIR_TRAINED_MODEL / save_file_name
    joblib.dump(pipeline_to_persist, save_path)
    print("Saving pipeline...")


def run_training() -> None:
    """Train the model."""
    print("Reading data...")
    original_data = pd.read_csv(DIR_DATASET / "original_data.csv")
    X_train, X_test, y_train, y_test = train_test_split(original_data, original_data["SalePrice"])
    print("Training...")
    price_pipe.fit(X_train, y_train)

    save_pipeline(price_pipe)


if __name__ == "__main__":
    run_training()
