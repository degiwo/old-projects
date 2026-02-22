from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/result")
def post_result(score: int, score_opponent: int, name_opponent: str):
    return {"message": f"Received result: {score} - {score_opponent} against {name_opponent}"}
