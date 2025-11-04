    # Laden der Umgebungsvariablen aus der .env-Datei
    # Stellt sicher, dass das Skript die gleichen DB-Zugangsdaten wie Ihr Server verwendet
    if [ -f .env ]; then
      export $(cat .env | sed 's/#.*//g' | xargs)
    fi

    # --- Konfiguration ---
    # Zieldatei für den SQL-Dump
    OUTPUT_FILE="assets/db/seed1.sql"

    # PostgreSQL-Verbindungsparameter
    # Diese werden aus den Umgebungsvariablen (process.env in server.js) übernommen
    DB_USER='shift_schedule_db_user'
    DB_PASSWORD='8QCdzFCFFC6NWcCcVnnxfNfo6ZpqbFSw'
    DB_HOST='dpg-d3vr2tili9vc73cub46g-a.frankfurt-postgres.render.com'
    DB_PORT='5432'
    DB_NAME='shift_schedule_db'

    # --- pg_dump Befehl ---
    echo "🚀 Erstelle einen Dump der Datenbank '${DB_NAME}' auf Host '${DB_HOST}'..."

    # Wir setzen das Passwort über eine Umgebungsvariable, damit es nicht im Prozessbaum sichtbar ist.
    export PGPASSWORD=$DB_PASSWORD

    # Führt pg_dump aus und speichert das Ergebnis in der Zieldatei.
    # --clean: Fügt 'DROP TABLE' Anweisungen hinzu.
    # --if-exists: Verhindert Fehler, wenn die Tabellen nicht existieren.
    # --inserts: Nutzt 'INSERT' anstelle von 'COPY', was portabler ist.
    pg_dump \
      --host=$DB_HOST \
      --port=$DB_PORT \
      --username=$DB_USER \
      --dbname=$DB_NAME \
      --clean \
      --if-exists \
      --inserts \
      --file=$OUTPUT_FILE

    # Passwort-Variable wieder löschen
    unset PGPASSWORD

    # --- Ergebnis ---
    if [ $? -eq 0 ]; then
      echo "✅ Datenbank-Dump erfolgreich erstellt. Bereinige die Datei..."

        # NEU: Entfernt die \restrict und \unrestricted Zeilen aus der erstellten Datei.
        # Funktioniert sowohl auf Linux/macOS (sed) als auch unter Windows mit Git Bash.
        sed -i '/^\\restrict/d' "$OUTPUT_FILE"
        sed -i '/^\\unrestrict/d' "$OUTPUT_FILE"

        echo "✅ Datei '${OUTPUT_FILE}' wurde bereinigt und ist einsatzbereit."
      else
        echo "❌ Fehler beim Erstellen des Datenbank-Dumps."
        exit 1
      fi