# Virtumi Home

Virtumi Home ist die App zur Steuerung des eigenen Smart Homes auf Android, iOS und Windows. Sie verbindet Häuser, Etagen, Räume und Geräte mit der Virtumi-Cloud und unterstützt unter anderem Matter, Smart-LED und das Control Panel.

Technisch ist es eine Flutter-App im Material-3- und Soft-UI-Stil. Daten und Anmeldung laufen über Supabase (Auth, Postgres, Realtime, RLS); der Zustand wird mit Riverpod verwaltet, die Navigation mit GoRouter.

## Features

- Supabase-Authentifizierung (Login, Register, Session-Guard)
- Hierarchie: Häuser → Etagen → Räume → Geräte (mit Fallback aus `device_location_settings`)
- Geräte-Config: Netzwerk, Datum/Zeit, Cloud (Virtumi/MQTT), Matter, Update, Allgemein, Standort, Passwort
- Control Panel: Parameter (`cp_parameters`), Tastendruck (`cp_btn_requests`)
- Smart LED: LED-Streifen (`smart_led_settings`), Trigger (`smart_led_triggers`) mit Realtime
- UDP-Gerätesuche beim Hinzufügen, Sensordaten (`device_data`), Live-Update-Status
- Realtime auf Allgemein-, Netzwerk-, Smart-LED- und Update-Status-Tabellen
- Mock-Repositories für lokale Entwicklung ohne Supabase

## Supabase starten

```bash
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Alternativ die VS-Code-Launch-Konfiguration in `.vscode/launch.json` nutzen.

## Projektstruktur

```
lib/
├── core/           # Theme, Widgets, Navigation, Supabase-Hilfen
├── features/       # home, devices, rooms, auth, settings, …
└── shared/
    ├── models/
    ├── domain/     # Repository-Interfaces
    ├── data/       # Supabase- + Mock-Implementierungen
    └── providers/
```

## Architektur

```
UI → Riverpod Providers → Repository-Interface → Supabase (Standard) / Mock (Dev-Override)
```

Repository-Provider in `lib/shared/providers/repository_providers.dart` tauschen; UI bleibt unverändert.

## Tests

```bash
flutter analyze
flutter test
```
