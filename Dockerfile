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

# Define environment variables
ENV MYSQL_SERVER=db \
  MYSQL_USER=ragwebui \
  MYSQL_PASSWORD=ragwebui \
  MYSQL_DATABASE=ragwebui \
  SECRET_KEY=${SECRET_KEY} \
  ACCESS_TOKEN_EXPIRE_MINUTES=30 \
  EMBEDDINGS_PROVIDER=openai \
  OPENAI_API_KEY=${OPENAI_API_KEY} \
  OPENAI_API_BASE=${OPENAI_API_BASE} \
  OPENAI_MODEL=gpt-4 \
  CHROMA_DB_HOST=chromadb.railway.internal \
  CHROMA_DB_PORT= \
  VECTOR_STORE_TYPE=chroma \
  MINIO_ENDPOINT=minio:9000 \
  MINIO_ACCESS_KEY=minioadmin \
  MINIO_SECRET_KEY=minioadmin \
  MINIO_BUCKET_NAME=documents \
  TZ=Asia/Shanghai

# Run the application
ENTRYPOINT ["./entrypoint.sh"]
