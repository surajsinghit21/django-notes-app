FROM python:3.9

# Set working directory
WORKDIR /app/backend

# Copy requirements first (improves Docker layer caching)
COPY requirements.txt .

# Install system dependencies
RUN apt-get update && \
    apt-get install -y gcc default-libmysqlclient-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir mysqlclient
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose Django port
EXPOSE 8000

# Start Django application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
