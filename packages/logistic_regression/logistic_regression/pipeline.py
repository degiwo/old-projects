from sklearn.pipeline import Pipeline

import preprocessors as pp
import model
import config

model_pipeline = Pipeline(
    [
        (
            "impute_with_mean",
            pp.ImputeWithMean(features_to_impute=config.IMPUTE_WITH_MEAN)
        ),

        (
            "impute_with_most_frequent",
            pp.ImputeWithMostFrequentValue(features_to_impute=config.IMPUTE_WITH_MOST_FREQUENT)
        ),

        (
            "drop_features",
            pp.DropFeatures(features_to_drop=config.DROP_FEATURES)
        ),

        (
            "model",
            model.Model()
        )
    ]
)
