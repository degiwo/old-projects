"""
Definition of pipeline: assign here the transformers/estimators
"""

from sklearn.pipeline import Pipeline

import preprocessors as pp


PIPELINE_NAME = "linear_regression"

price_pipe = Pipeline([
    ("feature_selector", pp.FeatureSelector())
])
