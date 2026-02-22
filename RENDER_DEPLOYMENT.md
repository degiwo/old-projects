# Render Deployment Guide

This guide explains how to deploy the Snooker application on Render using Docker Compose.

## Prerequisites

- Render account (free or paid)
- Docker installed locally (for testing)
- Git repository with all files

## Local Testing

Before deploying to Render, test the Docker setup locally:

```bash
# Build and start all services
docker-compose up --build

# Access the application
# Frontend: http://localhost:4200
# Backend API: http://localhost:8000
# Backend docs: http://localhost:8000/docs
```

## Deployment to Render

### Option 1: Deploy as a Single Web Service (Multi-container)

Render supports deploying Docker Compose files directly. This is the recommended approach for combined frontend + backend.

1. **Push your code to GitHub** (Render deploys from Git)

2. **Create a new Web Service on Render**
   - Go to [Render Dashboard](https://dashboard.render.com)
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Select the branch to deploy (e.g., main)

3. **Configure the Web Service**
   - **Name**: `snooker-app` (or your preferred name)
   - **Region**: Choose closest to your users
   - **Branch**: `main` (or your deployment branch)
   - **Runtime**: `Docker`
   - **Build Command**: (leave empty - uses Dockerfile)
   - **Start Command**: (leave empty - uses Dockerfile)

4. **Environment Variables** (in Render dashboard)
   - Set any environment variables if needed
   - No special setup required for Docker Compose

5. **Advanced Settings**
   - **Docker Command**: (leave empty)
   - **Dockerfile**: `docker-compose.yml` with the following build command:
     ```bash
     docker-compose up
     ```

### Option 2: Deploy as Separate Services (Advanced)

If you want frontend and backend as separate Render services:

#### Deploy Backend

1. Create a new Web Service for backend
2. Build from: Python
3. Build Command: `pip install -r requirements.txt`
4. Start Command: `uvicorn main.py:app --host 0.0.0.0 --port $PORT`

#### Deploy Frontend

1. Create a new Web Service for frontend
2. Build from: Node
3. Build Command: `npm install && npm run build`
4. Start Command: `npm start`
5. Environment Variable: Set `API_URL` to your backend service URL

## Production Considerations

### 1. Update CORS Settings

Modify `apps/backend/main.py` to restrict CORS to your domain:

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://your-render-url.onrender.com"],
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### 2. Frontend API URL

The frontend API URL is set via the `API_URL` build argument in `docker-compose.yml`. 

For Render deployment, you may need to modify the build args in a `render.yaml` file:

```yaml
services:
  - type: docker
    name: snooker-app
    dockerfilePath: ./docker-compose.yml
    envVars:
      - key: API_URL
        value: https://your-backend-render-url.onrender.com
```

### 3. Database Setup (Future)

When adding a database:
- Add a new service to `docker-compose.yml` (e.g., PostgreSQL)
- Update backend to connect to database
- Create migrations if needed

### 4. Health Checks

The `docker-compose.yml` includes a health check for the backend. Render respects these in production.

## Monitoring

- **Render Dashboard**: Monitor logs, deployments, and resource usage
- **Backend Docs**: Access at `https://your-render-url/docs` (FastAPI swagger UI)
- **Logs**: Check Render's real-time logs for errors

## Troubleshooting

### Deployment fails to build

- Check Render build logs for errors
- Ensure all required files are in the repository
- Verify Node and Python versions match your development environment

### Frontend can't reach backend

- Check the `API_URL` environment variable is set correctly
- Verify CORS is configured for your Render domain
- Check network connectivity between frontend and backend containers

### Port issues

- Render assigns a random port (stored in `$PORT` environment variable)
- Update your start commands to use `$PORT` if needed

## Manual Deployment Commands

If you need to deploy manually using Render's CLI:

```bash
# Install Render CLI (optional)
npm install -g render-cli

# Deploy from local Docker Compose
docker-compose up

# Push to production
git push origin main
```

## Updates

To update your deployment:

1. Make code changes locally
2. Test with `docker-compose up --build`
3. Commit and push to GitHub
4. Render will automatically detect changes and redeploy

For more information, see [Render Docker Documentation](https://render.com/docs/docker).
