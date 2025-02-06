FROM python:3.11-slim

WORKDIR /backend  # Adjusted to reflect the new structure

# Install system dependencies
RUN apt-get update && apt-get install -y \
  build-essential \
  default-libmysqlclient-dev \
  pkg-config \
  netcat-traditional \
  && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY backend/requirements.txt .

# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy entrypoint script first
COPY backend/entrypoint.sh .
RUN chmod +x entrypoint.sh

# Copy the rest of the application
COPY backend .
# Create uploads directory
RUN mkdir -p uploads

# Set Python path
ENV PYTHONPATH=/backend

# Run the application
ENTRYPOINT ["./entrypoint.sh"]
