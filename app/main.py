from fastapi import FastAPI
from contextlib import asynccontextmanager
from app.core.logging import setup_logging, get_logger

# Initialize logger for this module
logger = get_logger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Setup logging configuration
    setup_logging()
    logger.info("FastAPI application started successfully")
    yield
    logger.info("Shutting down FastAPI application")


app = FastAPI(title="Learning MLOps", lifespan=lifespan)


@app.get("/")
def root():
    return {"message": "Hello World"}
