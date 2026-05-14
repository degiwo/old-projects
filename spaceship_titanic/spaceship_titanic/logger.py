# This class is the overall logger for this project

import logging

from spaceship_titanic.config import PATH_LOGS_FOLDER


logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

log_handler = logging.FileHandler(PATH_LOGS_FOLDER + "spaceship_titanic.log")
log_formatter = logging.Formatter(
    "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
log_handler.setFormatter(log_formatter)

logger.addHandler(log_handler)
