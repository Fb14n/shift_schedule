# Dockerfile
FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    build-essential libpq-dev \
  && rm -rf /var/lib/apt/lists/*

# Pinne pip auf eine ältere Version vor Installation
RUN python -m pip install --upgrade "pip==23.2.1"

RUN pip install pgadmin4==8.*

# WICHTIG: Setze die folgenden Umgebungsvariablen in deiner Render.com-Umgebung
# auf sichere Werte, um den initialen Admin-Benutzer zu erstellen.
ENV PGADMIN_DEFAULT_EMAIL="admin@example.com"
ENV PGADMIN_DEFAULT_PASSWORD="admin"

# Server-Modus aktivieren und auf allen Interfaces lauschen
ENV PGADMIN_SERVER_MODE=True
ENV PGADMIN_LISTEN_ADDRESS="0.0.0.0"
ENV PGADMIN_LISTEN_PORT=80

EXPOSE 80
CMD ["pgadmin4"]