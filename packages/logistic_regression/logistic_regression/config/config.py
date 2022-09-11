import pathlib
import logistic_regression

# paths
PACKAGE_ROOT = pathlib.Path(logistic_regression.__file__).resolve().parent
PIPELINE_PATH = PACKAGE_ROOT / "trained_models"
PIPELINE_NAME = "logistic_regression"
DATA_PATH = PACKAGE_ROOT / "datasets"
DATA_NAME = "titanic.csv"
TEST_PATH = PACKAGE_ROOT / "datasets"
TEST_NAME = "test.csv"

# model
TARGET = "Survived"
TEST_SIZE_RATIO = 0.25

# features
NA_NOT_ALLOWED = [
    "Fare"
]

DROP_FEATURES = [
    "PassengerId", "Name", "Cabin",
    "Ticket", "Pclass", "Sex", "Embarked"
]

IMPUTE_WITH_MEAN = [
    "Age"
]

IMPUTE_WITH_MOST_FREQUENT = [
    "Embarked"
]
