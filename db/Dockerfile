FROM postgres:16-alpine

# Optional: eigene Config oder Init-Skripte
#COPY init.sql /docker-entrypoint-initdb.d/

# Render erwartet, dass dein Container auf PORT reagiert
# Wir setzen den Postgres-Port auf denselben Wert
ENV PORT=5432
EXPOSE 5432

CMD ["postgres"]