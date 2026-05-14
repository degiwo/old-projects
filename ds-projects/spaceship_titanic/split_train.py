# Split the data in train.csv to train and test data sets.

import pandas as pd
from sklearn.model_selection import train_test_split

from spaceship_titanic.config import (
    PATH_DATA_FOLDER,
    FILE_NAME_ORIGINAL_DATA,
    FILE_NAME_TRAIN_DATA,
    FILE_NAME_TEST_DATA,
)
from spaceship_titanic.logger import logger


def read_original_data() -> pd.DataFrame:
    data_path = PATH_DATA_FOLDER + FILE_NAME_ORIGINAL_DATA
    try:
        df = pd.read_csv(data_path)
        logger.info("Original data successfully read")
        logger.debug(f"Original data shape: {df.shape}")
        return df
    except FileNotFoundError:
        logger.error(
            f"Original data not found, please check if {data_path} exists",
            exc_info=True,
        )


def split_and_save(data: pd.DataFrame) -> None:
    """
    Use to split the original data to train and test for building a model.
    """
    try:
        train_data, test_data = train_test_split(
            data, test_size=0.2, random_state=0
        )
        train_data.to_csv(PATH_DATA_FOLDER + FILE_NAME_TRAIN_DATA)
        test_data.to_csv(PATH_DATA_FOLDER + FILE_NAME_TEST_DATA)
        logger.info("Train and test data successfully splitted")
        logger.debug(f"Train data shape: {train_data.shape}")
        logger.debug(f"Test data shape: {test_data.shape}")
    except TypeError:
        logger.error(
            f"Input data is {type(data)}, but DataFrame is needed to split",
            exc_info=True,
        )


if __name__ == "__main__":
    logger.info("split_train.py script started")
    original_data = read_original_data()
    split_and_save(original_data)
    logger.info("split_train.py script ended")
    logger.info("###########################################")
