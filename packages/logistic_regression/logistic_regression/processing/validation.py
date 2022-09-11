import pandas as pd

from logistic_regression.config import config

def validate_inputs(input_data):
    validated_data = input_data.copy()

    if input_data[config.NA_NOT_ALLOWED].isnull().any().any():
        validated_data = validated_data.dropna(
            axis=0, subset=config.NA_NOT_ALLOWED
        )

    return validated_data
