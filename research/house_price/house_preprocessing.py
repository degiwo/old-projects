import pandas as pd
from sklearn.model_selection import train_test_split

from house_config import DATA_PATH, ORIGINAL_DATA_FILE, TARGET_VARIABLE, NUMERIC_VARIABLES

def read_original_data() -> pd.DataFrame:
    try:
        data = pd.read_csv(f"../../{DATA_PATH}{ORIGINAL_DATA_FILE}")
        print(f"Rows: {data.shape[0]}, Columns: {data.shape[1]}")
        return data
    except Exception as e:
        print(e)

def select_numeric_features(input: pd.DataFrame) -> pd.DataFrame:
    assert all(var in input.columns for var in NUMERIC_VARIABLES), "Not all NUMERIC_VARIABLES present."

    output = input[NUMERIC_VARIABLES]
    print(f"Rows: {output.shape[0]}, Columns: {output.shape[1]}")
    return output

def check_missing_values(input: pd.DataFrame):
    assert all(input.isnull().sum()==0), "There are missing values."
    print("No Missing values.")

def check_train_test_data(X_train: pd.DataFrame, X_test: pd.DataFrame):
    assert X_train.shape[0] > 0, "X_train has no rows."
    assert X_train.shape[1] > 0, "X_train has no columns."
    assert X_test.shape[0] > 0, "X_test has no rows."
    assert X_test.shape[1] > 0, "X_test has no columns."
    print("X_train and X_test are ready for modeling.")
