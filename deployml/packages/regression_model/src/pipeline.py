"""
Definition of pipeline: assign here the transformers/estimators
"""
from sklearn.linear_model import LinearRegression
from sklearn.pipeline import Pipeline

import processing.preprocessors as pp

PIPELINE_NAME = "linear_regression"

price_pipe = Pipeline([
    ("feature_selector", pp.FeatureSelector()),
    ("tester", pp.Tester()),
    ("linear_model", LinearRegression())
])
