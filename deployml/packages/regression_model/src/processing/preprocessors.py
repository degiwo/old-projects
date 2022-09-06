import pandas as pd
from sklearn.base import BaseEstimator, TransformerMixin

NUMERIC_VARIABLES = [
    # 'Id',
    'MSSubClass',
    # 'LotFrontage',
    'LotArea',
    'OverallQual',
    'OverallCond',
    'YearBuilt',
    'YearRemodAdd',
    # 'MasVnrArea',
    'BsmtFinSF1',
    'BsmtFinSF2',
    'BsmtUnfSF',
    'TotalBsmtSF',
    '1stFlrSF',
    '2ndFlrSF',
    'LowQualFinSF',
    'GrLivArea',
    'BsmtFullBath',
    'BsmtHalfBath',
    'FullBath',
    'HalfBath',
    'BedroomAbvGr',
    'KitchenAbvGr',
    'TotRmsAbvGrd',
    'Fireplaces',
    # 'GarageYrBlt',
    'GarageCars',
    'GarageArea',
    'WoodDeckSF',
    'OpenPorchSF',
    'EnclosedPorch',
    '3SsnPorch',
    'ScreenPorch',
    'PoolArea',
    'MiscVal',
    'MoSold',
    'YrSold'
]


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


class Tester(BaseEstimator, TransformerMixin):
    def __init__(self) -> None:
        super().__init__()

    def fit(self, X, y):
        return self

    def transform(self, X):
        assert all(X.isnull().sum() == 0), "There are missing values."
        assert X.shape[0] > 0, "X has no rows."
        assert X.shape[1] > 0, "X has no columns."

        return X
