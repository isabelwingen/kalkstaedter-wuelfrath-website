# Coolify-Notfall-Anleitung

Diese Anleitung erklärt, wie jemand den Kalkstädter-Webserver neustarten kann, falls die Website nicht erreichbar ist.

---

## Was ist Coolify?

Coolify ist die Verwaltungsoberfläche auf unserem Server. Dort laufen zwei Dienste:

- **kalk-website** -- die öffentliche Vereinswebsite
- **Umami** -- die Besucherstatistik

---

## Zugang zu Coolify

1. Öffne im Browser: **http://kalkstaedter.tail25b46e.ts.net:8000**
2. Melde dich mit den Coolify-Zugangsdaten an

**Voraussetzung:** Du musst im Tailscale-Netzwerk sein. Falls du keinen Zugang hast, frag Isabel.

---

## Website neustarten

1. Nach dem Login landest du auf dem Coolify-Dashboard
2. Klicke auf das **Projekt**, in dem die kalk-website läuft
3. Du siehst eine Liste der Services -- klicke auf die **kalk-website**
4. Oben auf der Seite gibt es Buttons:
   - **Restart** -- Startet den Service neu (empfohlen als erster Versuch)
   - **Redeploy** -- Baut die App komplett neu und startet sie (dauert länger, hilft wenn Restart nicht reicht)
5. Warte bis der Status wieder auf **Running** (grün) steht

---

## Umami neustarten

Gleicher Ablauf wie oben, nur wähle den **Umami**-Service statt der kalk-website.

---

## Logs prüfen

Falls der Neustart das Problem nicht löst:

1. Klicke auf den betroffenen Service
2. Gehe zum Reiter **Logs**
3. Dort siehst du die letzten Ausgaben der App -- Fehlermeldungen helfen bei der Diagnose

---

## Wenn nichts hilft

Falls weder Restart noch Redeploy helfen:

1. Prüfe ob der Server selbst erreichbar ist (ping kalkstaedter.tail25b46e.ts.net)
2. Kontaktiere Isabel
3. Im Notfall: Per SSH auf den Server verbinden und Docker-Container manuell prüfen:
   ```
   ssh root@kalkstaedter.tail25b46e.ts.net
   docker ps
   docker restart <container-name>
   ```
