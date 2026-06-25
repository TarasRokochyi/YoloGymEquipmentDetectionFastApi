# Use the Python image
FROM python:3.10-slim

# Install necessary packages
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/*

# Copy application files into the Docker image
COPY . /app

# Specify the directory where the application will run
WORKDIR /app

RUN pip install --upgrade pip setuptools wheel

# Install CPU-only torch first to avoid pulling the GPU (~3GB) build
RUN pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu

# Install necessary Python packages
RUN pip install -r requirements.txt

# Run the application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
