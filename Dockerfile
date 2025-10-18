# Sample Dockerfile with two targets: react and fastapi
# Usage (PowerShell):
#   docker build -t my-frontend --target react .
#   docker build -t my-backend --target fastapi .
#
# Assumptions:
# - For react: your package.json and source are in ./frontend and build outputs to /frontend/build
# - For fastapi: your FastAPI app entry is ./backend/app/main.py exposing `app`

# -------- React target --------
FROM node:20-alpine AS react-build
WORKDIR /frontend
COPY frontend/package*.json ./
RUN npm ci --no-audit --no-fund
COPY frontend/. .
RUN npm run build

FROM nginx:1.27-alpine AS react
COPY --from=react-build /frontend/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# -------- FastAPI target --------
FROM python:3.11-slim AS fastapi
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
WORKDIR /backend
# If you have requirements.txt, copy and install first for caching
# COPY backend/requirements.txt ./
# RUN pip install --no-cache-dir -r requirements.txt
# Minimal deps for sample
RUN pip install --no-cache-dir fastapi uvicorn[standard]
COPY backend/. .
# Change APP_MODULE if your path differs
ENV APP_MODULE=app.main:app
EXPOSE 8000
CMD ["sh", "-c", "uvicorn ${APP_MODULE} --host 0.0.0.0 --port 8000"]
