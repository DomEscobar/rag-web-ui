#!/bin/sh

# Use environment variables provided by Railway for MySQL
echo "Waiting for MySQL at ${MYSQL_SERVER}.."
while ! nc -z db.railway.internal; do
  sleep 1
done
echo "MySQL started"

echo "Running migrations..."
alembic upgrade head

echo "Starting application..."
uvicorn app.main:app --host 0.0.0.0 --port 8000
