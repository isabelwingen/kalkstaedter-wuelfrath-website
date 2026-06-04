# CLAUDE.md

## Projekt

Website des Querflötenorchesters Kalkstädter Wülfrath e.V.  
Rails 8.1 · Ruby 4.0 · SQLite · Deployed auf Hetzner via Coolify

## Entwicklung

```bash
bundle install
bin/rails db:prepare db:seed
bin/dev
```

## Vor jedem Commit

```bash
bin/rubocop -f github
```

Fehler müssen behoben werden bevor committed wird.

## Architektur

- **Datenbank:** SQLite (3 Datenbanken: production, cache, queue)
- **Hintergrundverarbeitung:** Solid Queue, läuft im Puma-Prozess (`SOLID_QUEUE_IN_PUMA=true`)
- **Caching:** Solid Cache
- **Datei-Uploads:** Active Storage, lokal auf Disk (`/rails/storage` in production)
- **E-Mail:** Resend (production), letter_opener (development)
- **Auth:** Rails 8 Authentication (sessions-basiert, kein Devise)

## Models

| Model | Zweck |
|---|---|
| `User` | Admin-Login, hat `has_secure_password` + `generates_token_for :password_reset` |
| `Session` | Login-Sessions, gehört zu User |
| `Event` | Veranstaltungen (Auftritte, Partys) |
| `Post` | Berichte/News-Artikel |
| `PressLink` | Zeitungsartikel-Links |
| `InfoChannel` | Social-Media-Kanäle (Instagram, Facebook, WhatsApp) |
| `SiteSetting` | Key-Value-Konfiguration (z.B. `musikschule_anmeldung`) |

## Routen

- `/` — Startseite
- `/admin` — Admin-Dashboard (Login erforderlich)
- `/admin/login` → `sessions#new`
- `/passwords/new` — Passwort-Reset anfordern
- Öffentliche Seiten: `/ueber-uns`, `/mitmachen`, `/musikschule`, `/chronik`, `/impressum`, `/datenschutz`

## Admin-Bereich

Alle Admin-Controller erben von `Admin::BaseController`, der `require_authentication` erzwingt.  
Authentifizierung läuft über `app/controllers/concerns/authentication.rb`.  
Admin-User: `isabel.wingen@gmail.com`

## Deployment

**Server:** Hetzner CX23 (2 vCPU, 4 GB RAM), IP `49.13.13.196`  
**Coolify:** http://49.13.13.196:8000  
**App (temporär):** http://ec65ceyz2q9h8cq5e3ttctd4.49.13.13.196.sslip.io

Push auf `main` triggert automatisch Redeploy in Coolify.

### Coolify Umgebungsvariablen

| Variable | Beschreibung |
|---|---|
| `RAILS_MASTER_KEY` | Aus `config/master.key` — **Runtime only** |
| `RESEND_API_KEY` | API Key von resend.com — **Runtime only** |
| `MAILER_FROM` | Absenderadresse (default: `onboarding@resend.dev`) |
| `APP_HOST` | Domain für Mail-Links |
| `SOLID_QUEUE_IN_PUMA` | `true` — Solid Queue im Puma-Prozess |

### Persistent Storage

Volume Mount in Coolify: `/rails/storage`  
Enthält SQLite-Datenbanken und Active Storage Uploads.

### SSL / Domain

`force_ssl` und `assume_ssl` sind aktuell deaktiviert (`production.rb`).  
Nach Einrichtung einer echten Domain über Coolify wieder aktivieren.

### Nützliche Befehle auf dem Server

```bash
# In App-Container einloggen
ssh root@49.13.13.196
docker exec -it <container-name> bash

# Rails-Konsole
docker exec <container-name> bin/rails console

# Seeds erneut ausführen
docker exec <container-name> bin/rails db:seed

# Logs
docker logs <container-name> -f
```

Container-Name: `docker ps | grep -v coolify`

## Active Storage

Storage-Service in production heißt `:render` (historisch, zeigt auf `/rails/storage`).  
Konfiguration in `config/storage.yml`.

## Frontend-Prinzipien

### ROCA (Resource-Oriented Client Architecture)
- Jede URL repräsentiert eine Ressource und ist direkt aufrufbar (kein versteckter State)
- Der Server rendert vollständiges HTML — kein client-seitiges Rendering
- JavaScript darf nur als progressive Enhancement verwendet werden, nie als Voraussetzung
- Browser-Back/Forward funktioniert immer korrekt

### Progressive Enhancement
- Die Seite muss ohne JavaScript vollständig funktionieren
- JS verbessert die Erfahrung, ist aber nie notwendig für Kernfunktionen
- Turbo/Stimulus nur für Enhancements, nicht für kritische Flows

### CSS
- **Kein Inline-CSS** (`style="..."` ist verboten)
- Styles gehören in Stylesheet-Dateien
- Keine `!important`-Verwendung ohne zwingenden Grund

### Accessibility
- Alle interaktiven Elemente müssen per Tastatur bedienbar sein
- Bilder benötigen sinnvolle `alt`-Texte (kein `alt=""` bei informativen Bildern)
- Formulare: `label` muss mit `input` verknüpft sein (`for`/`id` oder `f.label`)
- Semantisches HTML bevorzugen (`nav`, `main`, `article`, `section`, `header`, `footer`)
- Ausreichende Farbkontraste einhalten (WCAG AA)
- Screen-Reader-Tests bei neuen Komponenten berücksichtigen

## Mailer

- Production: Resend via `delivery_method = :resend`
- Development: letter_opener öffnet Mails im Browser
- Mailer-Views: `app/views/password_mailer/`
