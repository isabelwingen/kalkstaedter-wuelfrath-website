# Kalkstädter Wülfrath – Website

Rails 8.1 · Ruby 4.0 · SQLite · Coolify auf Hetzner

## Server

**Produktion:** http://ec65ceyz2q9h8cq5e3ttctd4.49.13.13.196.sslip.io  
**Admin:** http://ec65ceyz2q9h8cq5e3ttctd4.49.13.13.196.sslip.io/admin

## Lokale Entwicklung

```bash
bundle install
bin/rails db:prepare db:seed
bin/dev
```

## Deployment

Push auf `main` löst automatisch einen Redeploy in Coolify aus.

## Umgebungsvariablen (Coolify)

| Variable | Beschreibung |
|---|---|
| `RAILS_MASTER_KEY` | Aus `config/master.key` |
| `RESEND_API_KEY` | API Key von resend.com |
| `MAILER_FROM` | Absenderadresse (z.B. no-reply@kalkstaedter-wuelfrath.de) |
| `APP_HOST` | Domain für Mail-Links (z.B. www.kalkstaedter-wuelfrath.de) |
