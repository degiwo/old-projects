# Minimal Todo App

Start everything with:

    docker-compose up --build

- Backend: FastAPI on port 8000 (http://localhost:8000)
- Frontend: Angular dev server on port 4200 (http://localhost:4200)
- Postgres: port 5432

Frontend proxies API requests (/api) to the backend. Backend will create the todos table on first start.
