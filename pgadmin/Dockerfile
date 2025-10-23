# Dockerfile
FROM python:3.11-slim

# Systemabhängigkeiten (falls nötig)
RUN apt-get update && apt-get install -y \
    build-essential libpq-dev \
  && rm -rf /var/lib/apt/lists/*

# pip updaten und pgadmin installieren
RUN python -m pip install --upgrade pip
RUN pip install pgadmin4==8.*

# Konfiguration: Server-Modus aus (oder anpassen)
ENV PGADMIN_CONFIG_SERVER_MODE=False
ENV PGADMIN_LISTEN_ADDRESS=0.0.0.0
ENV PGADMIN_LISTEN_PORT=80

EXPOSE 80

# Start ohne sudo/venv: Modul starten
CMD ["python3", "-m", "pgadmin4"]