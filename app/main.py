from fastapi import FastAPI

app = FastAPI(title="Learning MLOps")


@app.get("/")
def root():
    return {"message": "Hello World"}
