FROM python:3.9-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# System deps (kept minimal; wheels should cover scientific libs on common platforms)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./

RUN pip install --upgrade pip \
    && pip install -r requirements.txt

COPY . .

# Ensure the data directory exists (used by sqlite DBs)
RUN mkdir -p /app/data

EXPOSE 5000

# Default to running the Flask server
ENV FLASK_APP=serve.py
CMD ["flask", "run", "--host=0.0.0.0", "--port", "5000"]


