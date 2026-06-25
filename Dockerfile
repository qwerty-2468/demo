FROM python:3.11-slim

WORKDIR /app

# Install Flask directly inside the container image
RUN pip install flask

COPY app.py .

# Expose port 5000 so the outside world can map to it
EXPOSE 5000

CMD ["python", "app.py"]