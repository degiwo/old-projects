import pandas as pd

from split_train import read_original_data
from spaceship_titanic.config import (
    COLUMN_TARGET,
    COLUMN_ONEHOT,
    COLUMN_IMPUTE,
    COLUMN_TOTAL_BILL,
    PATH_DATA_FOLDER,
    FILE_NAME_TRAIN_DATA,
    FILE_NAME_TEST_DATA,
)


def test_read_original_data_returns_dataframe():
    df = read_original_data()
    assert isinstance(df, pd.DataFrame)


def test_original_data_has_all_relevant_columns():
    df = read_original_data()
    list_all_relevant_columns = [
        [COLUMN_TARGET],
        COLUMN_ONEHOT,
        COLUMN_IMPUTE,
        COLUMN_TOTAL_BILL,
    ]
    flat_list = [
        item for sublist in list_all_relevant_columns for item in sublist
    ]
    assert all([x in df.columns for x in set(flat_list)])


def test_splited_data_is_valid():
    train_data = pd.read_csv(PATH_DATA_FOLDER + FILE_NAME_TRAIN_DATA)
    test_data = pd.read_csv(PATH_DATA_FOLDER + FILE_NAME_TEST_DATA)
    assert isinstance(train_data, pd.DataFrame)
    assert isinstance(test_data, pd.DataFrame)
