# CHRONOS — App zur Schichtplanung

Willkommen — diese README gibt einen kompakten Überblick über das Projekt, wie man sich schnell einarbeitet und wie man lokal loslegt.

## Kurzbeschreibung
Chronos ist eine Flutter\-Mobile\-App zur
Verwaltung und Anzeige von Arbeitsschichten und Abwesenheiten\. Die App spricht ein Backend an und nutzt eine PostgreSQL\-Datenbank\. Ziel ist schnelle Einsicht in Schichtpläne und einfache Administration durch Admin\-Funktionen\.

## Was im Repository wichtig ist
- `lib/` — Flutter\-Quellcode (Einstieg: `lib/main.dart`, `lib/router.dart`)
- `lib/services/` — API\-Clients und Service\-Logik
- `lib/ui/` — Widgets, Screens, Themes
- `android/`, `ios/` etc. — Plattform\-Projekte
- `server.js` — einfaches lokales Backend (Node)
- `docker-compose.yml` — Starten von Diensten (z\.B\. Postgres / pgAdmin)
- `pubspec.yaml` / `package.json` — Abhängigkeiten für App / Node

## Schnellüberblick
1. Öffne `lib/main.dart` — Einstiegspunkt der App.
2. Schau in `lib/services/` nach API\-Aufrufen (Suche nach `API_BASE_URL`).
3. UI: `lib/ui/` enthält Screens und wiederverwendbare Widgets.
4. Backend\-Studie: `server.js` zeigt API\-Endpunkte lokal; DB\-Schema und Seeds in `db/`\.
5. Docker: `docker-compose.yml` startet PostgreSQL und pgAdmin für lokalen Test.


## Delokal die App ausführen

1. App installieren \
   -  `apk`-Datei auf dem Endgerät installieren 

2. App öffnen und loslegen

### Anmerkung zum delokalen Server (`render.com`)

- Wenn die App mit dem delokalen Server betrieben wird, werden `server.js` und die Datenbank auf `render.com` gehostet.
- `render.com` schaltet inaktive Webservices nach ca. 10 Minuten ohne Anfragen automatisch ab. Der erste Request danach kann länger dauern (bis zu etwa 1 Minute), weil der Service wieder hochfahren muss.
- Es kann gelegentlich zu Verbindungsproblemen kommen. Falls Daten einmal nicht geladen werden, bitte die Seite per `Pull-to-Refresh` neu laden oder kurz warten und den Request erneut ausführen.

## Login 
Es gibt zurzeit zwei unterschiedliche Firmen. Die Möglichkeit eine neue Firma zu registrieren gibt es derzeit noch nicht.  
Anschließend werde ich die Login-Daten zweier Admins aufführen, damit Zugang zur App besteht.

#### Chronos 
    Personalnummer: 1001
    Passwort: test123

#### Company GmbH
    Personalnummer: 1011
    Passwort: test

---
### Hinweis zu Beispieldaten

- Alle in der Datenbank enthaltenen Daten sind frei erfunden und dienen ausschließlich Demonstrations\- und Testzwecken.
- Die Einträge stellen keine realen Personen, Unternehmen oder Ereignisse dar; Ähnlichkeiten sind rein zufällig.
- Die Daten sind nicht realitätsnah und können Fehler oder Inkonsistenzen enthalten.
- Verwende die Beispieldaten nicht für produktive Zwecke und speichere keine sensiblen oder echten Daten in der Demo\-Datenbank.
- Angezeigte Login\-Daten und User-Profile sind Testkonten.



