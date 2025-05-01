from typing import Any
from loguru import logger
import sys


def setup_logging() -> None:
    """Configure logging for the application."""
    # Remove default handler
    logger.remove()

    # Add custom logging configuration
    logger.add(
        sys.stderr,
        format="<green>{time:YYYY-MM-DD HH:mm:ss}</green> | <level>{level: <8}</level> | <cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - <level>{message}</level>",
        level="INFO",
    )


def get_logger(name: str) -> Any:
    """Get a logger instance with the given name.

    Args:
        name: The name for the logger, typically __name__

    Returns:
        A logger instance
    """
    return logger.bind(name=name)
