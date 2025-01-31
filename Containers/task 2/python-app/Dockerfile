# Use a lightweight Python image
FROM python:3.9-alpine

# Set working directory
WORKDIR /app

# Copy application files
COPY app.py .
COPY config.py . 
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port (dynamic via env variable)
EXPOSE 5000

# Run the application
CMD ["sh", "-c", "python app.py"]
```