# This script evaluates the trained model pipeline
# in various ways with train data

import joblib

from numpy import ndarray
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import cross_val_predict
from sklearn.metrics import (
    confusion_matrix,
    precision_score,
    recall_score,
    f1_score,
    precision_recall_curve,
    roc_curve,
    roc_auc_score,
)
from dagshub import DAGsHubLogger

from config import (
    PATH_DATA_FOLDER,
    PATH_MODEL_FOLDER,
    PATH_LOGS_FOLDER,
    FILE_NAME_MODEL_PIPELINE,
    FILE_NAME_TRAIN_DATA,
    FILE_NAME_TEST_DATA,
)


def plot_precision_recall_vs_threshold(
    precisions: ndarray, recalls: ndarray, thresholds: ndarray
) -> None:
    """
    input parameters should be output from
    sklearn.metrics.precision_recall_curve
    """
    plt.plot(thresholds, precisions[:-1], "b--", label="Precision")
    plt.plot(thresholds, recalls[:-1], "g-", label="Recall")
    plt.legend(loc="center right", fontsize=16)
    plt.xlabel("Threshold", fontsize=16)
    plt.grid(True)


def plot_roc_curve(fpr: ndarray, tpr: ndarray, label=None) -> None:
    """
    input parameters should be output from
    sklearn.metrics.roc_curve
    """
    plt.plot(fpr, tpr, linewidth=2, label=label)
    plt.plot([0, 1], [0, 1], "k--")
    plt.axis([0, 1, 0, 1])
    plt.xlabel("False Positive Rate (Fall-Out)", fontsize=16)
    plt.ylabel("True Positive Rate (Recall)", fontsize=16)
    plt.grid(True)


if __name__ == "__main__":
    logger = DAGsHubLogger(
        metrics_path=PATH_LOGS_FOLDER + "metrics.csv", should_log_hparams=False
    )
    pipeline = joblib.load(PATH_MODEL_FOLDER + FILE_NAME_MODEL_PIPELINE)
    # decision_function vs. predict_proba
    if hasattr(pipeline, "decision_function"):
        method = "decision_function"
    else:
        method = "predict_proba"

    # train data
    train_data = pd.read_csv(PATH_DATA_FOLDER + FILE_NAME_TRAIN_DATA)
    X_train = train_data.iloc[:, :-1]
    y_train = train_data.iloc[:, -1]

    # cross validation confusion matrix
    pred_cv = cross_val_predict(pipeline, X_train, y_train, cv=3)
    print("Confusion matrix with 3-fold CV: ")
    print(confusion_matrix(y_train, pred_cv))

    # Precision, recall and f1 score
    print(f"Precision score: {precision_score(y_train, pred_cv)}")
    print(f"Recall score: {recall_score(y_train, pred_cv)}")
    print(f"F1 score: {f1_score(y_train, pred_cv)}")

    # Decision function for threshold with precision recall curve
    pred_scores = cross_val_predict(
        pipeline, X_train, y_train, cv=3, method=method
    )
    if method == "predict_proba":
        pred_scores = pred_scores[:, 1]
    prec, rec, thresh = precision_recall_curve(y_train, pred_scores)
    plot_precision_recall_vs_threshold(prec, rec, thresh)
    plt.show()

    # New threshold
    threshold_new = 0.4  # -0.71
    pred_new = pred_scores >= threshold_new
    print(f"Precision score (new thrsh): {precision_score(y_train, pred_new)}")
    logger.log_metrics(train_precision=precision_score(y_train, pred_cv))
    print(f"Recall score (new thrsh): {recall_score(y_train, pred_new)}")
    logger.log_metrics(train_recall=recall_score(y_train, pred_cv))
    print(f"F1 score (new thrsh): {f1_score(y_train, pred_new)}")
    logger.log_metrics(train_f1=f1_score(y_train, pred_cv))

    # ROC curve
    fpr, tpr, thresh = roc_curve(y_train, pred_scores)
    plot_roc_curve(fpr, tpr)
    plt.title(f"AUC: {roc_auc_score(y_train, pred_scores)}")
    plt.show()
    logger.log_metrics(train_auc=roc_auc_score(y_train, pred_scores))

    # test data
    test_data = pd.read_csv(PATH_DATA_FOLDER + FILE_NAME_TEST_DATA)
    X_test = test_data.iloc[:, :-1]
    y_test = test_data.iloc[:, -1]
    print(f"Testing score: {pipeline.score(X_test, y_test)}")
    logger.log_metrics(test_score=pipeline.score(X_test, y_test))

    logger.save()
    logger.close()
