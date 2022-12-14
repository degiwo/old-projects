from logistic_regression.config import config
from logistic_regression.processing import data_management
from logistic_regression import pipeline

def run_model():
    data = data_management.read_train_data()
    X, y = data_management.get_X_y_from_data(data)
    x_train, x_test, y_train, y_test = data_management.get_train_test_split(X, y)

    pipeline.model_pipeline.fit(x_train, y_train)
    data_management.save_pipeline(pipeline.model_pipeline)


if __name__ == '__main__':
    run_model()
