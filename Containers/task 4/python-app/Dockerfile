# Use a lightweight Python base image
FROM python:3.9-alpine

# Set the working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY app.py .

# Expose ports required by the app
EXPOSE 80

# Run Flask using Gunicorn (better for production)
CMD ["python", "app.py"]

```