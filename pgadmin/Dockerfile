# Dockerfile
# Option A: eigenes Image, pip auf ältere Version pinnen (funktioniert oft)
FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    build-essential libpq-dev \
  && rm -rf /var/lib/apt/lists/*

# Pinne pip auf eine ältere Version vor Installation
RUN python -m pip install --upgrade "pip==23.2.1"

RUN pip install pgadmin4==8.*

ENV PGADMIN_CONFIG_SERVER_MODE=False
ENV PGADMIN_LISTEN_ADDRESS=0.0.0.0
ENV PGADMIN_LISTEN_PORT=80

EXPOSE 80
CMD ["pgadmin4"]