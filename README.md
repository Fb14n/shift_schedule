-richtige Id-Verteilung ind er DB
-edit users
-edit/add shift-types
-edit/add companies 
-edit multiple days at once




# Shift Schedule - App zur Schichtplanung

![Build & Release Flutter](https://github.com/fabianberger/shift_schedule/actions/workflows/release.yml/badge.svg)

Willkommen zum Shift Schedule Projekt! Dies ist eine mobile Anwendung, die mit Flutter entwickelt wurde, um die Verwaltung und Anzeige von Arbeitsschichten zu vereinfachen. Sie bietet eine übersichtliche Kalenderansicht, in der Benutzer ihre zugewiesenen Schichten (z. B. Früh-, Spät-, Nachtschicht) sowie Abwesenheiten wie Urlaub oder Krankheit einsehen können.

## ✨ Features

- **Dynamische Kalenderansicht:** Zeigt alle Schichten für den aktuellen Monat an.
- **Farbcodierte Schichten:** Verschiedene Schicht-Typen sind zur besseren Übersicht farblich markiert.
- **Benutzer-Login:** Sicherer Zugang zur App über ein Authentifizierungssystem.
- **Admin-Funktionen:** Administratoren haben erweiterte Rechte (z. B. zur Verwaltung von Urlaubsanträgen).
- **API-Anbindung:** Lädt die Schichtdaten von einer externen API.
- **Automatisierte Releases:** Eine CI/CD-Pipeline erstellt und veröffentlicht bei jedem Push auf den `main`-Branch eine neue Android-APK.

## 🚀 Getting Started: Lokale Einrichtung

Folge diesen Schritten, um das Projekt lokal aufzusetzen und auszuführen.

### Voraussetzungen

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (stabile Version)
- Ein Code-Editor wie [VS Code](https://code.visualstudio.com/) oder [Android Studio](https://developer.android.com/studio)
- [Docker](https://www.docker.com/get-started) (optional, nur für das lokale Backend)

### Installation & Ausführung

1.  **Repository klonen:**
    ```sh
    git clone <DEINE_REPO_URL>
    cd shift_schedule
    ```

2.  **Abhängigkeiten installieren:**
    ```sh
    flutter pub get
    ```

3.  **Umgebungsvariablen einrichten:**
    Erstelle eine Datei namens `.env` im Stammverzeichnis des Projekts. Diese Datei wird von `main.dart` geladen, um Konfigurationen wie den API-Endpunkt zu verwalten. Füge den folgenden Inhalt hinzu und passe die Werte an:

    ```env
    # Beispiel für eine .env Datei
    API_BASE_URL="http://deine-api-adresse.com/api"
    ```

4.  **App starten:**
    Verbinde ein Gerät oder starte einen Emulator und führe den folgenden Befehl aus:
    ```sh
    flutter run
    ```

## ⚙️ Backend & Datenbank

Das Projekt ist für die Zusammenarbeit mit einem PostgreSQL-Backend konzipiert. Im `pgadmin/` Verzeichnis befindet sich eine Docker-Konfiguration, um eine pgAdmin-Instanz zu starten.

Diese Konfiguration ist für das Deployment auf Plattformen wie [Render.com](https://render.com/) optimiert und erwartet, dass die Zugangsdaten als Umgebungsvariablen bereitgestellt werden.

- `PGADMIN_DEFAULT_EMAIL`: E-Mail für den Admin-Login.
- `PGADMIN_DEFAULT_PASSWORD`: Passwort für den Admin-Login.

## 📦 Build & Release (CI/CD)

Das Projekt verwendet GitHub Actions, um den Build- und Release-Prozess zu automatisieren.

- **Workflow-Datei:** `.github/workflows/release.yml`
- **Trigger:** Ein Push auf den `main`-Branch.

**Der Prozess umfasst folgende Schritte:**

1.  Einrichten der Java- und Flutter-Umgebung.
2.  Aktualisieren der App-Abhängigkeiten (`flutter pub upgrade`).
3.  Erstellen einer `app-release.apk`.
4.  Automatisches Erstellen eines neuen Git-Tags (z. B. `v1`, `v2`, ...).
5.  Erstellen eines neuen GitHub-Releases mit der generierten APK als Anhang.

## 📂 Projektstruktur

```
.
├── android/          # Natives Android-Projekt
├── .github/          # GitHub Actions Workflows (CI/CD)
├── lib/              # Haupt-Quellcode der Flutter-App
│   ├── services/     # API-Anbindung
│   ├── ui/           # Widgets, Screens und Themes
│   ├── main.dart     # Einstiegspunkt der App
│   └── router.dart   # Navigation und Routen-Management
├── pgadmin/          # Docker-Konfiguration für pgAdmin
└── pubspec.yaml      # Projekt-Metadaten und Abhängigkeiten
```

## 🤝 Contributing

Pull Requests sind willkommen! Für größere Änderungen eröffne bitte zuerst ein Issue, um zu diskutieren, was du ändern möchtest. Stelle sicher, dass du alle Tests aktualisierst.

## 📜 Lizenz

Dieses Projekt steht unter der MIT-Lizenz. Weitere Informationen findest du in der `LICENSE`-Datei.
