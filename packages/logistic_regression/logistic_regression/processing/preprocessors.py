import numpy as np
import pandas as pd

class DropFeatures:
    def __init__(self, features_to_drop=None):
        self.features = features_to_drop
    
    def fit(self, X, y=None):
        return self
    
    def transform(self, X):
        return X.drop(columns=self.features)

class ImputeWithMean:
    def __init__(self, features_to_impute=None):
        self.features = features_to_impute
        self.means = dict()
    
    def fit(self, X, y=None):
        for feature in self.features:
            self.means[feature] = np.mean(X[feature])
        return self
    
    def transform(self, X):
        X = X.copy()
        for feature in self.features:
            X[feature].fillna(self.means[feature], inplace=True)
        return X

class ImputeWithMostFrequentValue:
    def __init__(self, features_to_impute=None):
        self.features = features_to_impute
        self.values = dict()
    
    def fit(self, X, y=None):
        for feature in self.features:
            self.values[feature] = X[feature].value_counts().idxmax()
        return self
    
    def transform(self, X):
        X = X.copy()
        for feature in self.features:
            X[feature].fillna(self.values[feature], inplace=True)
        return X
