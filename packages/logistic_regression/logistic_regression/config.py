# pipeline
PIPELINE_NAME = 'logistic regression'
TEST_SIZE_RATIO = 0.25

# data
DATA_FILE_PATH = "titanic.csv"
TARGET = "Survived"

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
