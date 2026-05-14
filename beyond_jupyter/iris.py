from abc import ABC, abstractmethod
import pandas as pd
from sklearn.datasets import load_iris
from typing import Tuple

class DataLoader(ABC):
    @abstractmethod
    def load_data(self):
        pass

class DataLoaderIris(DataLoader):
    def load_data(self) -> Tuple[pd.DataFrame, pd.Series]:
        return load_iris(return_X_y=True, as_frame=True)

if __name__ == "__main__":
    dl = DataLoaderIris()
    X, y = dl.load_data()
    print(X.head())
    print(y.head())
