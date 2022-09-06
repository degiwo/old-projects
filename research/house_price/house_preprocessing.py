"""
This file stores all functions for the house price model.
"""

# Import packages
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.base import TransformerMixin, BaseEstimator

from house_config import DATA_PATH, ORIGINAL_DATA_FILE, TARGET_VARIABLE, NUMERIC_VARIABLES


# Data reading
def read_original_data() -> pd.DataFrame:
    try:
        data = pd.read_csv(f"../../{DATA_PATH}{ORIGINAL_DATA_FILE}")
        print(f"Rows: {data.shape[0]}, Columns: {data.shape[1]}")
        return data
    except Exception as e:
        print(e)


# Feature selection
class FeatureSelector(BaseEstimator, TransformerMixin):
    def __init__(self) -> None:
        super().__init__()

    def fit(self, X, y):
        return self

    def transform(self, X) -> pd.DataFrame:
        assert isinstance(NUMERIC_VARIABLES, list), "NUMERIC_VARIABLES is not a list"

        X = X.copy()
        X = X[NUMERIC_VARIABLES]
        return X


# Modeling process
def get_target_data(input: pd.DataFrame):
    assert TARGET_VARIABLE in input.columns, f"{TARGET_VARIABLE} not in DataFrame present."

    target_data = input[TARGET_VARIABLE]
    return target_data


def get_train_test_data(features: pd.DataFrame, target: pd.Series):
    X_train, X_test, y_train, y_test = train_test_split(
        features,
        target,
        test_size=0.2,
        random_state=42
    )
    return X_train, X_test, y_train, y_test


# Tests
def check_missing_values(input: pd.DataFrame):
    assert all(input.isnull().sum() == 0), "There are missing values."
    print("No Missing values.")


def check_shape(X: pd.DataFrame):
    assert X.shape[0] > 0, "X has no rows."
    assert X.shape[1] > 0, "X has no columns."
    print("X is ready for modeling.")


class Tester(BaseEstimator, TransformerMixin):
    def __init__(self) -> None:
        super().__init__()

    def fit(self, X, y):
        return self

    def transform(self, X):
        check_missing_values(X)
        check_shape(X)

        return X
