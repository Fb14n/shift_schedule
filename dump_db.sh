#!/usr/bin/env bash
# bash
# Load env
if [ -f .env ]; then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

OUTPUT_FILE=assets/db/seed1.sql

DB_USER='shift_schedule_db_user'
DB_PASSWORD='8QCdzFCFFC6NWcCcVnnxfNfo6ZpqbFSw'
DB_HOST='dpg-d3vr2tili9vc73cub46g-a.frankfurt-postgres.render.com'
DB_PORT='5432'
DB_NAME='shift_schedule_db'

echo "🚀 Erstelle IDENTITY-SAFE Seed-Dump für '${DB_NAME}'..."

export PGPASSWORD=$DB_PASSWORD

TEMP_SCHEMA="assets/db/_schema.sql"
TEMP_DATA="assets/db/_data.sql"
TEMP_CONSTRAINTS="assets/db/_constraints_dynamic.sql"

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

# --- DYNAMISCHE ERSTELLUNG DER CONSTRAINTS ---

echo "🔧 Erstelle dynamische, idempotente DO-Blöcke für Constraints..."

# Lösche alte dynamische Datei
rm -f "$TEMP_CONSTRAINTS"

# Extrahieren, Transformieren und Speichern von ALTER TABLE ADD CONSTRAINT (Primary/Foreign/Check/Unique)
# Regex erfasst den Constraint-Namen: ADD CONSTRAINT (name)
grep -E '^ALTER TABLE ONLY.*ADD CONSTRAINT' "$TEMP_SCHEMA" | while read line; do
    # Den CONSTRAINT-Namen extrahieren
    CONSTRAINT_NAME=$(echo "$line" | sed -E 's/.*ADD CONSTRAINT ([a-zA-Z0-9_]+) .*/\1/')
    # Die Tabelle extrahieren (zwischen 'ONLY ' und ' ADD')
    TABLE_NAME=$(echo "$line" | sed -E 's/^ALTER TABLE ONLY (.*) ADD CONSTRAINT.*/\1/')

    # Den DO-Block in die temporäre Constraints-Datei schreiben
    cat << EOF >> "$TEMP_CONSTRAINTS"
DO \$\$ BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = '$CONSTRAINT_NAME'
        AND conrelid = '$TABLE_NAME'::regclass
    ) THEN
        $line;
    END IF;
END \$\$;

EOF
done

# Extrahieren, Transformieren und Speichern von CREATE UNIQUE INDEX
# Regex erfasst den Index-Namen: CREATE UNIQUE INDEX (name)
grep -E '^CREATE UNIQUE INDEX' "$TEMP_SCHEMA" | while read line; do
    # Den INDEX-Namen extrahieren
    INDEX_NAME=$(echo "$line" | sed -E 's/CREATE UNIQUE INDEX ([a-zA-Z0-9_]+) .*/\1/')

    # Den DO-Block für UNIQUE INDEX in die temporäre Constraints-Datei schreiben
    cat << EOF >> "$TEMP_CONSTRAINTS"
DO \$\$ BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_class c
        JOIN pg_index i ON i.indexrelid = c.oid
        WHERE c.relname = '$INDEX_NAME'
    ) THEN
        $line;
    END IF;
END \$\$;

EOF
done

# --- BEREINIGUNG DER SCHEMA-DATEI ---

echo "🔧 Bereinige Schema-Dump (IF NOT EXISTS und entferne Constraints/Indizes)..."

# CREATE TABLE -> CREATE TABLE IF NOT EXISTS
sed -i 's/CREATE TABLE /CREATE TABLE IF NOT EXISTS /g' "$TEMP_SCHEMA"

# Sequences safe machen
sed -i 's/CREATE SEQUENCE /CREATE SEQUENCE IF NOT EXISTS /g' "$TEMP_SCHEMA"

# Entferne alle originalen ALTER TABLE ... ADD CONSTRAINT Zeilen
sed -i '/^ALTER TABLE ONLY.*ADD CONSTRAINT/d' "$TEMP_SCHEMA"

# Entferne alle originalen CREATE UNIQUE INDEX Zeilen
sed -i '/^CREATE UNIQUE INDEX/d' "$TEMP_SCHEMA"


echo "🔧 Patche INSERTs (ON CONFLICT DO NOTHING)..."

# Erstens: entferne pauschale Anhänge (alte Ausgaben)
sed -i 's/);$/) ON CONFLICT DO NOTHING;/g' "$TEMP_DATA"

echo "🔧 Baue finale Seed-Datei (Schema, Constraints (dynamisch), Daten)..."

# 1) Füge Schema (ohne Constraints), dynamische Constraints und Data zusammen
cat "$TEMP_SCHEMA" "$TEMP_CONSTRAINTS" "$TEMP_DATA" > "${OUTPUT_FILE}.raw"


# --- ALLGEMEINE BEREINIGUNG ---

# 2) Entferne Blockkommentare (/* ... */) robust mit perl (multiline)
if command -v perl >/dev/null 2>&1; then
  perl -0777 -pe 's{/\*.*?\*/}{}gs' "${OUTPUT_FILE}.raw" > "${OUTPUT_FILE}.noblock"
else
  # fallback: einfache awk-basierte Entfernung (nicht ganz so robust für inline-blocks)
  awk 'BEGIN{in=0} /\/\*/{in=1} !in{print} /\*\//{in=0; next}' "${OUTPUT_FILE}.raw" > "${OUTPUT_FILE}.noblock"
fi

# 3) Entferne Zeilen-Kommentare die mit -- beginnen (nach optionalem Whitespace).
sed -E '/^[[:space:]]*--/d' "${OUTPUT_FILE}.noblock" > "${OUTPUT_FILE}.nocomments"

# 4) Entferne psql meta-commands (\restrict / \unrestrict) falls noch vorhanden
sed -E '/^\\restrict/d' "${OUTPUT_FILE}.nocomments" | sed -E '/^\\unrestrict/d' > "${OUTPUT_FILE}.cleaned"

# 5) Entferne überflüssige leere Zeilen (zusammenfassen auf maximal eine leere Zeile)
awk 'NF==0{ if(blank==0){ print; blank=1 } next } { blank=0; print }' "${OUTPUT_FILE}.cleaned" > "${OUTPUT_FILE}.tmp"

# 6) Entferne fälschliche "ON CONFLICT DO NOTHING" in SELECT-Zeilen
sed -i "/^[[:space:]]*SELECT[[:space:]]/ s/ ON CONFLICT DO NOTHING//g" "${OUTPUT_FILE}.tmp"

# 7) Füge "ON CONFLICT DO NOTHING" nur bei INSERT-Zeilen hinzu, die es noch nicht haben
awk '{
  if ($0 ~ /^[[:space:]]*INSERT[[:space:]]+INTO/ && $0 !~ /ON CONFLICT DO NOTHING/) {
    sub(/;[[:space:]]*$/, " ON CONFLICT DO NOTHING;");
  }
  print
}' "${OUTPUT_FILE}.tmp" > "${OUTPUT_FILE}"

# Cleanup temporäre Dateien
rm -f "${OUTPUT_FILE}.raw" "${OUTPUT_FILE}.noblock" "${OUTPUT_FILE}.nocomments" "${OUTPUT_FILE}.cleaned" "${OUTPUT_FILE}.tmp"
rm -f "$TEMP_SCHEMA" "$TEMP_DATA" "$TEMP_CONSTRAINTS"

echo "✅ Fertig! Seed-Datei erstellt: ${OUTPUT_FILE}"