# Seeds sind idempotent – können jederzeit erneut ausgeführt werden.
require "open-uri"

def attach_image(record, url, filename)
  return if record.image.attached?
  file = URI.open(url)
  record.image.attach(io: file, filename: filename, content_type: "image/jpeg")
  puts "  → Bild geladen: #{filename}"
rescue => e
  puts "  → Bild konnte nicht geladen werden: #{e.message}"
end

def attach_local_image(record, path, filename)
  return if record.image.attached?
  content_type = File.extname(path) == ".png" ? "image/png" : "image/jpeg"
  record.image.attach(io: File.open(path), filename: filename, content_type: content_type)
  puts "  → Bild angehängt: #{filename}"
rescue => e
  puts "  → Bild konnte nicht angehängt werden: #{e.message}"
end

SEEDS_IMAGES = File.expand_path("seeds/images", __dir__)

BASE = "https://images.unsplash.com"

# ── Admin-User ────────────────────────────────────────────────────────────────
User.find_or_create_by!(email_address: "isabel.wingen@gmail.com") do |u|
  u.password = u.password_confirmation = SecureRandom.hex(16)
  puts "Admin-User erstellt: #{u.email_address} (Passwort per Reset-Link setzen)"
end

# ── Info-Kanäle ───────────────────────────────────────────────────────────────
channels = [
  { name: "Instagram",      platform: "instagram", url: "https://www.instagram.com/kalkstaedterwuelfrath/" },
  { name: "Facebook",       platform: "facebook",  url: "https://www.facebook.com/kalkstaedter/" },
  { name: "WhatsApp-Kanal", platform: "whatsapp",  url: "https://whatsapp.com/channel/0029Vb6bL0yGk1FufD0T5c2S" }
]

channels.each do |attrs|
  InfoChannel.find_or_create_by!(url: attrs[:url]) do |c|
    c.name     = attrs[:name]
    c.platform = attrs[:platform]
    puts "Info-Kanal erstellt: #{c.name}"
  end
end

# ── Veranstaltungen ───────────────────────────────────────────────────────────
events = [
  {
    title:      "Auftritt im Neandertal No. 1",
    event_type: "auftritt",
    starts_at:  Time.zone.parse("2026-07-05 15:00"),
    location:   "Neandertal No. 1, Wülfrath",
    ticket_url: nil,
    published:  true,
    description: "Ein Auftritt in kleinem, gemütlichem Rahmen: Die Kalkstädter spielen in der Gastronomie Neandertal No. 1. Eintritt frei – einfach vorbeikommen!",
    image_url:  "#{BASE}/photo-1558618666-fcd25c85cd64?w=900&q=80&fm=jpg",
    image_name: "neandertal-auftritt.jpg"
  },
  {
    title:      "Mallorca-Party",
    event_type: "party",
    starts_at:  Time.zone.parse("2026-06-06 20:00"),
    location:   "Vereinshaus, Flandersbacher Str. 19a, Wülfrath",
    ticket_url: "https://www.neanderticket.de/630251",
    published:  true,
    description: <<~TEXT,
      Hol dir das Mallorca-Feeling direkt nach Wülfrath! Freu dich auf eine legendäre Nacht voller Partyhits, guter Laune und ausgelassener Stimmung.

      Unser DJ bringt euch die größten Mallorca- und Schlagerhits auf die Tanzfläche – Mitsingen, Tanzen und Feiern garantiert! Egal ob mit Freunden, Kollegen oder der ganzen Clique: Diese Party wird fröhlich und unvergesslich.

      Euch erwarten:
      • Die besten Mallorca- & Partyhits
      • DJ-Sound und Partylicht
      • Gute Drinks & beste Stimmung
      • Mitsingen, Tanzen und Feiern bis spät in die Nacht

      Im Ticketpreis sind 3 Euro Mindestverzehr enthalten.
    TEXT
    image_path: "#{SEEDS_IMAGES}/mallorca-party.png",
    image_name: "mallorca-party.png"
  },
  {
    title:      "Maikonzert 2026 – Kalkstädter und Freunde",
    event_type: "auftritt",
    starts_at:  Time.zone.parse("2026-05-01 12:00"),
    location:   "Vereinshaus, Flandersbacher Str. 19a, Wülfrath",
    ticket_url: nil,
    published:  true,
    description: <<~TEXT,
      Der Maiausflug für die ganze Familie! Ab 12 Uhr wird auf dem Hof unseres Vereinshauses gefeiert.

      Für Sitzgelegenheiten, Bratwurst vom Grill, Kaffee, Kuchen und Getränke ist gesorgt. Für die Kinder gibt es eine Hüpfburg. Eintritt frei!
    TEXT
    image_path: "#{SEEDS_IMAGES}/maikonzert.png",
    image_name: "maikonzert.png"
  },
  {
    title:      "Rosenmontagsparty 2026",
    event_type: "party",
    starts_at:  Time.zone.parse("2026-02-16 19:00"),
    location:   "Vereinshaus, Flandersbacher Str. 19a, Wülfrath",
    ticket_url: nil,
    published:  true,
    description: "Die närrische Jahreszeit feiern wir gemeinsam im Vereinshaus! Kostüme erwünscht, gute Laune garantiert.",
    image_path: "#{SEEDS_IMAGES}/karnevalsparty.png",
    image_name: "karnevalsparty.png"
  }
]

events.each do |attrs|
  image_url  = attrs.delete(:image_url)
  image_path = attrs.delete(:image_path)
  image_name = attrs.delete(:image_name)
  event = Event.find_or_create_by!(title: attrs[:title], starts_at: attrs[:starts_at]) do |e|
    e.assign_attributes(attrs)
    puts "Veranstaltung erstellt: #{e.title}"
  end
  if image_path
    attach_local_image(event, image_path, image_name)
  else
    attach_image(event, image_url, image_name)
  end
end

# ── Berichte ──────────────────────────────────────────────────────────────────
posts = [
  {
    title:        "Deutsche Meisterschaft 2025 in Ulm – wir waren dabei!",
    published_at: Date.new(2025, 6, 3),
    published:    true,
    content: <<~TEXT,
      Ein unvergessliches Wochenende liegt hinter uns: Die Kalkstädter Wülfrath haben an der Deutschen Meisterschaft der Querflötenorchester 2025 in Ulm teilgenommen und eine beeindruckende Vorstellung abgeliefert.

      Nach monatelanger intensiver Vorbereitung unter der Leitung von Tanja Bohn traten wir gegen Ensembles aus dem ganzen Bundesgebiet an. Die Stimmung im Orchester war ausgezeichnet – und das hat man gehört!

      Wir sind unglaublich stolz auf unsere Musikerinnen und Musiker, die diesen besonderen Moment gemeinsam erlebt haben. Ein großes Dankeschön gilt auch unseren Familien und Fans, die uns tatkräftig unterstützt haben.
    TEXT
    image_url:  "#{BASE}/photo-1507838153414-b4b713384a76?w=900&q=80&fm=jpg",
    image_name: "deutsche-meisterschaft.jpg"
  },
  {
    title:        "Rückblick: Maikonzert 2026 – Frühlingsstimmung an der Flandersbacher Straße",
    published_at: Date.new(2026, 5, 2),
    published:    true,
    content: <<~TEXT,
      Der 1. Mai ist bei den Kalkstädtern Tradition: Auf dem Hof des Vereinshauses an der Flandersbacher Straße fand auch in diesem Jahr das beliebte Freiluftkonzert statt. Das Wetter spielte perfekt mit, die Sonne ließ sich den ganzen Tag nicht lumpen – und der Andrang war entsprechend riesig.

      Unter der Leitung von Laura Brunswig präsentierte das Orchester ein rein eigenes Programm – ohne Gastensemble. In zwei Teilen blätterten die Musiker durch ihr breites Repertoire: von klassischen Werken über Filmmusik bis hin zu schwungvollen Arrangements, die zum Mitwippen einluden.

      Für das leibliche Wohl war bestens gesorgt: Gegrilltes, Kaltgetränke und Kaffee hielten Besucher und Musikerinnen bei Laune. Die Kinder hatten ihre eigene Attraktion – eine Hüpfburg, die den ganzen Nachmittag in Betrieb war. Der Eintritt war wie immer frei.

      Ein gelungener Feiertag – wir freuen uns aufs nächste Jahr!
    TEXT
    image_url:  "#{BASE}/photo-1467810563316-b5476525c0f9?w=900&q=80&fm=jpg",
    image_name: "maikonzert-rueckblick.jpg"
  }
]

posts.each do |attrs|
  image_url  = attrs.delete(:image_url)
  image_name = attrs.delete(:image_name)
  post = Post.find_or_create_by!(title: attrs[:title]) do |p|
    p.assign_attributes(attrs)
    puts "Bericht erstellt: #{p.title}"
  end
  attach_image(post, image_url, image_name)
end

# ── Zeitungsartikel ───────────────────────────────────────────────────────────
press_links = [
  {
    title:        "Zum 1. Mai blättern die Kalkstädter in ihrem Repertoire",
    publication:  "Taeglich.ME",
    published_on: Date.new(2026, 4, 29),
    url:          "https://taeglich.me/wuelfrath/zum-1-mai-blaettern-die-kalkstaedter-in-ihrem-repertoire/"
  },
  {
    title:        "Wülfrath: So haben sich die Kalkstädter verändert",
    publication:  "RP Online",
    published_on: nil,
    url:          "https://rp-online.de/nrw/staedte/wuelfrath/wuelfrath-so-haben-sich-die-kalkstaedter-veraendert_aid-146981147"
  },
  {
    title:        "Wülfrath: Kalkstädter freuen sich über junge Musiker",
    publication:  "RP Online",
    published_on: nil,
    url:          "https://rp-online.de/nrw/staedte/wuelfrath/wuelfrath-kalkstaedter-freuen-sich-ueber-junge-musiker_aid-147107295"
  }
]

press_links.each do |attrs|
  PressLink.find_or_create_by!(url: attrs[:url]) do |p|
    p.assign_attributes(attrs)
    puts "Zeitungsartikel erstellt: #{p.title}"
  end
end

# ── Statische Seiteninhalte ───────────────────────────────────────────────────
static_pages = {
  "ueber_uns" => <<~HTML,
    <h1>Über uns</h1>
    <p>Die <strong>Kalkstädter Wülfrath</strong> sind ein Querflötenorchester aus Wülfrath, das seit Jahrzehnten Menschen jeden Alters für Musik begeistert. Zum Instrumentarium gehören neben Querflöten – vom Piccolo bis zum Kontrabass – ein vollständiger Percussionbereich mit Drum Set sowie Stabspielen wie Glockenspiel, Xylophon und Marimbaphon.</p>
    <h2>Unser Repertoire</h2>
    <p>Wir spielen das, was Spaß macht und Zuhörerinnen und Zuhörer begeistert:</p>
    <ul><li>Klassische Kompositionen für Querflötenorchester</li><li>Filmmusik, Pop &amp; Musicals</li><li>Marsch, Polka und lateinamerikanische Musik</li><li>Weihnachtsmusik im Swing-Stil</li></ul>
    <h2>Proben</h2>
    <p>Unter der Leitung von <strong>Laura Brunswig</strong> probt das Orchester jeden <strong>Donnerstagabend</strong> für zwei Stunden im Städtischen Gymnasium Wülfrath. Das Ergebnis ist ein abwechslungsreiches Jahresprogramm mit Konzerten, Partys und weiteren Veranstaltungen.</p>
    <h2>Uns für Auftritte anfragen</h2>
    <p>Ihr sucht ein Orchester für euren Festakt, euer Stadtfest, einen Empfang oder eine andere Veranstaltung? Wir sind offen für Anfragen aller Art – schreibt uns einfach: <a href="mailto:info@kalkstaedter-wuelfrath.de">info@kalkstaedter-wuelfrath.de</a></p>
    <h2>Mitgliedschaften</h2>
    <p>Wir sind Mitglied im <strong>Stadtkulturbund Wülfrath</strong> und im <strong>Stadtjugendring Wülfrath</strong>.</p>
    <h2>Kontakt</h2>
    <p><strong>Vereinshaus / Geschäftsstelle</strong><br>Flandersbacher Straße 19a<br>42489 Wülfrath</p>
    <p><strong>1. Vorsitzender: Sascha Köster</strong><br><a href="mailto:1.vorsitzender@kalkstaedter-wuelfrath.de">1.vorsitzender@kalkstaedter-wuelfrath.de</a></p>
  HTML
  "mitmachen" => <<~HTML,
    <h1>Mitmachen</h1>
    <p>Ob erfahrener Musiker, neugieriger Anfänger oder begeisterter Fan – es gibt bei uns verschiedene Wege, Teil der Kalkstädter Wülfrath zu werden.</p>
    <h2>Als Musikerin oder Musiker direkt einsteigen</h2>
    <p>Du beherrschst eines der folgenden Instrumente und möchtest in einem aktiven Orchester mitspielen? Dann freuen wir uns, dich kennen zu lernen:</p>
    <ul><li>Querflöte (Sopran, Alt, Bass, Kontrabass)</li><li>Perkussion (Drum Set, Mallets / Stabspiele)</li></ul>
    <p>Komm einfach zu einer Schnupperprobe vorbei – Donnerstagabend im Städtischen Gymnasium Wülfrath. Oder schreib uns: <a href="mailto:info@kalkstaedter-wuelfrath.de">info@kalkstaedter-wuelfrath.de</a></p>
    <h2>Als Anfänger – über die Musikschule einsteigen</h2>
    <p>Du interessierst dich für Querflöte oder Schlagwerk, hast aber noch keine oder wenig Erfahrung? Kein Problem. Unsere vereinseigene Musikschule bildet Kinder wie Erwachsene aus – ohne Vorkenntnisse, in eigenem Tempo.</p>
    <p>Das Ziel: wer möchte, findet Schritt für Schritt den Weg ins Orchester. Alle Infos zu Instrumenten, Unterrichtszeiten und Kosten gibt es auf der <a href="/musikschule">Musikschule-Seite</a>.</p>
    <h2>Als förderndes Mitglied</h2>
    <p>Du möchtest uns unterstützen, ohne selbst ein Instrument zu spielen? Auch das ist möglich. Als förderndes Mitglied trägst du dazu bei, dass unser Verein und seine Angebote erhalten bleiben. Meld dich gerne bei uns: <a href="mailto:info@kalkstaedter-wuelfrath.de">info@kalkstaedter-wuelfrath.de</a></p>
    <h2>Mitgliedsbeiträge</h2>
    <table><thead><tr><th>Mitgliedschaft</th><th>Beitrag</th></tr></thead><tbody><tr><td>Jugendliche</td><td>24,– € / Jahr</td></tr><tr><td>Erwachsene</td><td>60,– € / Jahr</td></tr></tbody></table>
    <p>Kosten für den Musikschulunterricht (30,– € / Monat) und eine eventuelle Instrumentenleihgebühr (20,– € / Monat) findest du auf der <a href="/musikschule">Musikschule-Seite</a>.</p>
  HTML
  "musikschule" => <<~HTML,
    <h1>Musikschule</h1>
    <p>Unsere vereinseigene Musikschule wurde <strong>2005 gegründet</strong> und richtet sich an musikbegeisterte Menschen jeden Alters – von Kindern ab dem Grundschulalter bis hin zu Erwachsenen, die sich ihren Traum vom Musizieren erfüllen möchten. Vorkenntnisse sind keine nötig.</p>
    <h2>Unterrichtete Instrumente</h2>
    <p>Wir unterrichten die Kerninstrumente unseres Orchesters:</p>
    <ul><li><strong>Querflöte</strong> – in allen Stimmlagen: Sopran (klassische Böhmflöte), Alt, Bass und Kontrabass. Wer mit der Sopranflöte beginnt, hat später die Möglichkeit, auf weitere Stimmlagen zu wechseln.</li><li><strong>Schlagwerk &amp; Mallets</strong> – Drum Set, Glockenspiel, Xylophon und Marimbaphon. Der Unterricht umfasst je nach Interesse sowohl rhythmische Grundlagen als auch melodisches Stabspielen.</li></ul>
    <p>Ein eigenes Instrument ist nicht zwingend nötig – wir verleihen Instrumente gegen eine kleine monatliche Leihgebühr.</p>
    <h2>Der Weg ins Orchester</h2>
    <p>Unser Ziel ist es, Schülerinnen und Schüler behutsam an das gemeinsame Musizieren heranzuführen. Der Weg dahin hat zwei natürliche Stufen:</p>
    <ol><li><strong>Einzelunterricht</strong> – Grundlagen, Haltung, Technik und erste Melodien. Im eigenen Tempo, individuell auf dich abgestimmt.</li><li><strong>Orchester</strong> – wer bereit ist, wächst ganz natürlich in das Orchester hinein. Es gibt keine feste Zeitvorgabe – das entscheiden wir gemeinsam.</li></ol>
    <h2>Unterricht</h2>
    <p>Der Unterricht findet <strong>einmal wöchentlich donnerstags</strong> statt – als <strong>Einzelunterricht à 30 Minuten</strong> im Städtischen Gymnasium Wülfrath.</p>
    <h2>Vereinsleben</h2>
    <p>Neben dem Unterricht pflegen wir das gemeinsame Miteinander: Ausflüge, Probenwochenenden, Kino- oder Pizzaabende und die ersten eigenen Auftritte machen die Musikschule zu mehr als nur Unterricht.</p>
    <h2>Kosten</h2>
    <table><thead><tr><th>Position</th><th>Betrag</th></tr></thead><tbody><tr><td>Vereinsbeitrag Jugendliche</td><td>24,– € / Jahr</td></tr><tr><td>Vereinsbeitrag Erwachsene</td><td>60,– € / Jahr</td></tr><tr><td>Musikschulunterricht</td><td>30,– € / Monat</td></tr><tr><td>Instrumentenleihgebühr (falls nötig)</td><td>20,– € / Monat</td></tr></tbody></table>
    <h2>Jetzt anmelden</h2>
    <p>Interesse geweckt? Wir freuen uns auf deine Nachricht – komm einfach auf uns zu, ganz unverbindlich: <a href="mailto:info@kalkstaedter-wuelfrath.de">info@kalkstaedter-wuelfrath.de</a></p>
  HTML
  "chronik" => <<~HTML,
    <h1>Chronik</h1>
    <p>Das Querflötenorchester Kalkstädter Wülfrath wurde <strong>1954</strong> ursprünglich als Spielmannszug des Schützenvereins gegründet.</p>
    <ol><li><strong>1954 – Gründung</strong><br>Gründung als Spielmannszug des Schützenvereins Wülfrath.</li><li><strong>1990er – Modernisierung</strong><br>Einführung der Notenlehre und Umstellung des Repertoires. Das Interesse engagierter Musiker – vor allem im Jugendbereich – wird geweckt.</li><li><strong>2005 – Konzertflöten &amp; Musikschule</strong><br>Umstellung des Instrumentariums von Spielmannsflöten auf Konzertflöten. Verpflichtung von Bernd Wysk als Musiklehrer und Dirigenten. Erweiterung des Flötensatzes. Gründung der vereinseigenen Musikschule.</li><li><strong>2008 – Neue musikalische Leitung</strong><br>Tanja Bohn (geb. Rödel) übernimmt die musikalische Leitung.</li><li><strong>2010 – Bernd Wysk</strong><br>Bernd Wysk gibt seine Tätigkeit als Dirigent ab.</li><li><strong>2019 – Laura Brunswig</strong><br>Im Mai 2019 übernimmt Laura Brunswig die musikalische Leitung – bis heute.</li></ol>
  HTML
  "impressum" => <<~HTML,
    <h1>Impressum</h1>
    <p>Angaben gemäß § 5 DDG (Digitale-Dienste-Gesetz)</p>
    <h2>Diensteanbieter</h2>
    <p><strong>Kalkstädter Wülfrath e.V.</strong><br>Tiegenhöfer Straße 4<br>42489 Wülfrath<br><a href="mailto:info@kalkstaedter-wuelfrath.de">info@kalkstaedter-wuelfrath.de</a></p>
    <h2>Vertretungsberechtigter Vorstand</h2>
    <p>1. Vorsitzender: Sascha Köster<br>Geschäftsführerin: Isabel König-Wingen<br>Schatzmeisterin: Heike Faubel</p>
    <h2>Vereinsregister</h2>
    <p>Registergericht: Amtsgericht Wuppertal<br>Registernummer: VR 10289</p>
    <h2>Inhaltlich verantwortlich gemäß § 18 Abs. 2 MStV</h2>
    <p>Sascha Köster, Tiegenhöfer Straße 4, 42489 Wülfrath</p>
    <h2>Haftung für Inhalte</h2>
    <p>Als Diensteanbieter sind wir gemäß § 7 Abs. 1 DDG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. Nach §§ 8 bis 10 DDG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen.</p>
    <h2>Haftung für Links</h2>
    <p>Unser Angebot enthält Links zu externen Websites Dritter, auf deren Inhalte wir keinen Einfluss haben. Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber verantwortlich. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Links umgehend entfernen.</p>
    <h2>Urheberrecht</h2>
    <p>Die durch die Seitenbetreiber erstellten Inhalte und Werke auf diesen Seiten unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechts bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers.</p>
  HTML
  "datenschutz" => <<~HTML
    <h1>Datenschutzerklärung</h1>
    <p><em>Stand: Juni 2026</em></p>
    <p>Der Schutz eurer persönlichen Daten ist uns wichtig. Diese Erklärung informiert darüber, welche Daten beim Besuch dieser Website erhoben werden und wie wir damit umgehen.</p>
    <h2>Verantwortliche Stelle</h2>
    <p>Kalkstädter Wülfrath e.V.<br>Tiegenhöfer Straße 4, 42489 Wülfrath<br><a href="mailto:info@kalkstaedter-wuelfrath.de">info@kalkstaedter-wuelfrath.de</a></p>
    <h2>Hosting</h2>
    <p>Diese Website wird auf einem Server von <strong>Hetzner Online GmbH</strong> (Deutschland) gehostet. Beim Aufruf der Website werden automatisch Server-Logfiles erstellt. Diese Daten werden ausschließlich zur Sicherstellung des technischen Betriebs verarbeitet und nicht mit anderen Daten zusammengeführt. Rechtsgrundlage ist Art. 6 Abs. 1 lit. f DSGVO. Die Logfiles werden nach spätestens 30 Tagen automatisch gelöscht.</p>
    <h2>Cookies</h2>
    <p>Diese Website verwendet keine Tracking- oder Analyse-Cookies. Lediglich für den internen Administrationsbereich wird ein technisch notwendiges Session-Cookie gesetzt, das nach dem Abmelden automatisch gelöscht wird.</p>
    <h2>Kontakt per E-Mail</h2>
    <p>Wenn ihr uns per E-Mail kontaktiert, werden eure Angaben zur Bearbeitung eurer Anfrage gespeichert. Wir geben diese Daten nicht ohne eure Einwilligung weiter. Rechtsgrundlage ist Art. 6 Abs. 1 lit. f DSGVO.</p>
    <h2>Externe Links</h2>
    <p>Diese Website enthält Links zu externen Diensten (Instagram, Facebook, WhatsApp). Wenn ihr diese Links anklickt, verlasst ihr unsere Website. Für die Datenverarbeitung auf diesen Seiten sind die jeweiligen Anbieter verantwortlich.</p>
    <h2>Keine Analyse-Tools</h2>
    <p>Wir setzen keine Web-Analyse-Dienste ein. Es werden keine Nutzerprofile erstellt.</p>
    <h2>Eure Rechte</h2>
    <p>Ihr habt jederzeit das Recht auf Auskunft (Art. 15 DSGVO), Berichtigung (Art. 16), Löschung (Art. 17), Einschränkung der Verarbeitung (Art. 18), Datenübertragbarkeit (Art. 20) und Widerspruch (Art. 21 DSGVO).</p>
    <p>Zuständige Aufsichtsbehörde für Nordrhein-Westfalen: Landesbeauftragte für Datenschutz und Informationsfreiheit NRW (LDI NRW), <a href="https://www.ldi.nrw.de" target="_blank" rel="noopener">www.ldi.nrw.de</a></p>
    <p>Für Anfragen zu euren Rechten: <a href="mailto:info@kalkstaedter-wuelfrath.de">info@kalkstaedter-wuelfrath.de</a></p>
  HTML
}

static_pages.each do |slug, content|
  StaticPageContent.find_or_create_by!(slug: slug) do |p|
    p.content = content.strip
    puts "Statische Seite erstellt: #{slug}"
  end
end

# Site-Einstellungen
SiteSetting.find_or_create_by(key: "musikschule_anmeldung") { |s| s.value = "freie_plaetze" }
SiteSetting.find_or_create_by(key: "ki_systemprompt") do |s|
  s.value = "Du bist ein Texter für den Verein Querflötenorchester Kalkstädter Wülfrath e.V. Verbessere den folgenden Text sprachlich: korrekte Rechtschreibung, flüssiger Stil, freundlicher Ton. Duze die Leser. Gib nur den verbesserten Text zurück, ohne Erklärungen."
end

puts "Seeds fertig."
