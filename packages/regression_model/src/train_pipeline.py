"""
tox runs this script which resembles the main file.
"""

import pathlib


DIR_ROOT_PACKAGE = pathlib.Path(__file__).resolve().parent
DIR_TRAINED_MODEL = DIR_ROOT_PACKAGE / "trained_models"
DIR_DATASET = DIR_ROOT_PACKAGE / "datasets"


def save_pipeline() -> None:
    """Persist the pipeline."""
    pass


def run_training() -> None:
    """Train the model."""
    print("Training...")


if __name__ == "__main__":
    run_training()
