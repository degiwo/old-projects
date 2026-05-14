from typing import Optional
import polars as pl
import seaborn as sns

# avoid the use of constant literals in our code and use named constants instead
COL_PASSENGER_ID = "PassengerId"
COL_SURVIVED = "Survived"
COL_PCLASS = "Pclass"
COL_NAME = "Name"
COL_SEX = "Sex"
COL_AGE = "Age"
COL_SIBSP = "SibSp"
COL_PARCH = "Parch"
COL_TICKET = "Ticket"
COL_FARE = "Fare"
COL_CABIN = "Cabin"
COL_EMBARKED = "Embarked"
COLS_USED_BY_MODEL = []

class Dataset:
    """explicitly represent the parameters that determine the data"""
    def __init__(self) -> None:
        self.raw_data = self.load_raw_data()

    def load_raw_data(self):
        return pl.read_csv("abc_titanic/data/raw.csv")
    
    def load_sample_data(self, num_samples: int):
        return self.raw_data.sample(num_samples, seed=42)


if __name__ == "__main__":
    dataset = Dataset()
    raw_data = dataset.raw_data
    print(raw_data)

    sns.countplot(
        raw_data.to_pandas(),
        x="Survived"
    )
