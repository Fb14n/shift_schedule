#!/bin/bash

CONTAINER_NAME="postgres-db"
DB_USER="myuser"
DB_NAME="mydatabase"
OUTPUT_FILE="./assets/db/seed.sql"

docker exec -it $CONTAINER_NAME pg_dump -U $DB_USER -d $DB_NAME > $OUTPUT_FILE

echo "Seed-Datei wurde aktualisiert: $OUTPUT_FILE"