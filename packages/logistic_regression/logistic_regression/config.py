import pathlib

# paths
PACKAGE_ROOT = pathlib.Path(__file__).resolve().parent
PIPELINE_NAME = PACKAGE_ROOT / 'logistic regression'
DATA_FILE_PATH = PACKAGE_ROOT / "datasets/titanic.csv"

# model
TARGET = "Survived"
TEST_SIZE_RATIO = 0.25

# features
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
