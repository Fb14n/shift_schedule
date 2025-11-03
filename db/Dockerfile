FROM postgres:16-alpine

# Mini Webserver hinzufügen
RUN apk add --no-cache python3

# Port 5432 = Postgres, $PORT = Render-HTTP
EXPOSE 5432

ENV PORT=10000
ENV POSTGRES_PASSWORD=devpassword
ENV POSTGRES_DB=shift_schedule

# Starte Postgres im Hintergrund, dann HTTP Server
CMD ["sh", "-c", "postgres & python3 -m http.server $PORT"]