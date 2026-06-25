# Use a lightweight Python image
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Copy our app code into the container
COPY app.py .

# Run the application when the container starts
CMD ["python", "app.py"]
