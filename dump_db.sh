    # Load env
    if [ -f .env ]; then
      export $(cat .env | sed 's/#.*//g' | xargs)
    fi

    # --- Konfiguration ---
    OUTPUT_FILE="assets/db/seed1.sql"

    DB_USER='shift_schedule_db_user'
    DB_PASSWORD='8QCdzFCFFC6NWcCcVnnxfNfo6ZpqbFSw'
    DB_HOST='dpg-d3vr2tili9vc73cub46g-a.frankfurt-postgres.render.com'
    DB_PORT='5432'
    DB_NAME='shift_schedule_db'

    echo "🚀 Erstelle IDENTITY-SAFE Seed-Dump für '${DB_NAME}'..."

    export PGPASSWORD=$DB_PASSWORD

    TEMP_SCHEMA="assets/db/_schema.sql"
    TEMP_DATA="assets/db/_data.sql"

    # 1) SCHEMA ohne Drops exportieren
    pg_dump \
      --host=$DB_HOST \
      --port=$DB_PORT \
      --username=$DB_USER \
      --dbname=$DB_NAME \
      --schema-only \
      --no-owner \
      --no-privileges \
      --file="$TEMP_SCHEMA"

    # 2) DATA mit INSERTS exportieren
    pg_dump \
      --host=$DB_HOST \
      --port=$DB_PORT \
      --username=$DB_USER \
      --dbname=$DB_NAME \
      --data-only \
      --inserts \
      --column-inserts \
      --file="$TEMP_DATA"

    unset PGPASSWORD

    echo "🔧 Patche Schema (IF NOT EXISTS)..."

    # CREATE TABLE → CREATE TABLE IF NOT EXISTS
    sed -i 's/CREATE TABLE /CREATE TABLE IF NOT EXISTS /g' "$TEMP_SCHEMA"

    # CREATE SEQUENCE → CREATE SEQUENCE IF NOT EXISTS
    sed -i 's/CREATE SEQUENCE /CREATE SEQUENCE IF NOT EXISTS /g' "$TEMP_SCHEMA"

    # ALTER TABLE ADD CONSTRAINT → ADD CONSTRAINT IF NOT EXISTS
    sed -i -E 's/ADD CONSTRAINT ([a-zA-Z0-9_]+)/ADD CONSTRAINT \1 IF NOT EXISTS/g' "$TEMP_SCHEMA"

    echo "🔧 Patche INSERTs (ON CONFLICT DO NOTHING + Spaltennamen in \"...\")..."

    # ON CONFLICT DO NOTHING
    sed -i 's/);$/) ON CONFLICT DO NOTHING;/g' "$TEMP_DATA"

    # Spaltenliste in doppelte Anführungszeichen setzen
    # Beispiel:
    # (id, type_name) → ("id", "type_name")
    sed -i -E 's/INSERT INTO ([^(]+)\(([a-zA-Z0-9_ ,]+)\)/INSERT INTO \1(\2)/' "$TEMP_DATA"
    sed -i -E 's/([ (])([a-zA-Z_][a-zA-Z0-9_]*)([, )])/\1"\2"\3/g' "$TEMP_DATA"

    echo "🔧 Baue finale Seed-Datei..."

    {
      echo "-- SAFE SEED FILE (IDEMPOTENT)"
      echo "-- Struktur (nur wenn nicht vorhanden):"
      cat "$TEMP_SCHEMA"
      echo ""
      echo "-- Daten (nur fehlende Zeilen werden eingefügt):"
      cat "$TEMP_DATA"
    } > "$OUTPUT_FILE"

    rm "$TEMP_SCHEMA" "$TEMP_DATA"

    echo "✅ Fertig! Seed-Datei erstellt: $OUTPUT_FILE"