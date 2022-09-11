from logistic_regression.processing import validation, data_management
from logistic_regression import __version__ as _version
import logging

_logger = logging.getLogger(__name__)

def make_prediction():
    data = data_management.read_test_data()
    X, y = data_management.get_X_y_from_data(data)

    _pipeline = data_management.load_pipeline()
    validated_data = validation.validate_inputs(X)
    results = _pipeline.predict(validated_data)

    _logger.info(
        f"Making prediction with model version: {_version} "
        f"Results: {results}"
    )

    return results


if __name__ == '__main__':
    pred = make_prediction()
    print(pred)
