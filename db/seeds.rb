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

BASE = "https://images.unsplash.com"

# ── Admin-User ────────────────────────────────────────────────────────────────
User.find_or_create_by!(email_address: "admin@kalkstaedter-wuelfrath.de") do |u|
  u.password = u.password_confirmation = ENV.fetch("ADMIN_PASSWORD", "changeme123!")
  puts "Admin-User erstellt: #{u.email_address}"
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
    image_url:  "#{BASE}/photo-1533174072545-7a4b6ad7a6c3?w=900&q=80&fm=jpg",
    image_name: "mallorca-party.jpg"
  },
  {
    title:      "Weihnachtskonzert 2026",
    event_type: "auftritt",
    starts_at:  Time.zone.parse("2026-12-13 17:00"),
    location:   "Vereinshaus, Flandersbacher Str. 19a, Wülfrath",
    ticket_url: nil,
    published:  true,
    description: <<~TEXT,
      Unser jährliches Weihnachtskonzert stimmt euch auf die besinnlichste Zeit des Jahres ein.

      Das Orchester der Kalkstädter präsentiert ein festliches Programm mit Weihnachtsklassikern, beschwingten Swing-Arrangements und natürlich dem ein oder anderen Überraschungsstück. Eintritt frei – über eine Spende freuen wir uns.
    TEXT
    image_url:  "#{BASE}/photo-1512389142860-9c449e58a543?w=900&q=80&fm=jpg",
    image_name: "weihnachtskonzert.jpg"
  },
  {
    title:      "Jahreskonzert 2026",
    event_type: "auftritt",
    starts_at:  Time.zone.parse("2026-11-08 17:00"),
    location:   "Stadthalle Wülfrath",
    ticket_url: nil,
    published:  true,
    description: <<~TEXT,
      Das Highlight des Vereinsjahres: Unser großes Jahreskonzert in der Stadthalle Wülfrath.

      Unter der musikalischen Leitung von Laura Brunswig präsentiert das Orchester das erarbeitete Jahresprogramm – von klassischen Werken bis hin zu modernen Arrangements aus Film, Pop und Musical.
    TEXT
    image_url:  "#{BASE}/photo-1465847899084-d164df4dedc6?w=900&q=80&fm=jpg",
    image_name: "jahreskonzert.jpg"
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
    image_url:  "#{BASE}/photo-1467810563316-b5476525c0f9?w=900&q=80&fm=jpg",
    image_name: "maikonzert.jpg"
  },
  {
    title:      "Rosenmontagsparty 2026",
    event_type: "party",
    starts_at:  Time.zone.parse("2026-02-16 19:00"),
    location:   "Vereinshaus, Flandersbacher Str. 19a, Wülfrath",
    ticket_url: nil,
    published:  true,
    description: "Die närrische Jahreszeit feiern wir gemeinsam im Vereinshaus! Kostüme erwünscht, gute Laune garantiert.",
    image_url:  "#{BASE}/photo-1514525253161-7a46d19cd819?w=900&q=80&fm=jpg",
    image_name: "rosenmontagsparty.jpg"
  },
  {
    title:      "Neujahrsempfang 2026",
    event_type: "sonstiges",
    starts_at:  Time.zone.parse("2026-01-11 15:00"),
    location:   "Vereinshaus, Flandersbacher Str. 19a, Wülfrath",
    ticket_url: nil,
    published:  true,
    description: "Der vereinsinterne Neujahrsempfang – wir stoßen gemeinsam auf das neue Vereinsjahr an und blicken auf das kommende Programm.",
    image_url:  "#{BASE}/photo-1481824429379-07aa5e5b0739?w=900&q=80&fm=jpg",
    image_name: "neujahrsempfang.jpg"
  }
]

events.each do |attrs|
  image_url  = attrs.delete(:image_url)
  image_name = attrs.delete(:image_name)
  event = Event.find_or_create_by!(title: attrs[:title], starts_at: attrs[:starts_at]) do |e|
    e.assign_attributes(attrs)
    puts "Veranstaltung erstellt: #{e.title}"
  end
  attach_image(event, image_url, image_name)
end

# ── Berichte ──────────────────────────────────────────────────────────────────
posts = [
  {
    title:        "Deutsche Meisterschaft 2025 in Ulm – wir waren dabei!",
    published_at: Date.new(2025, 6, 3),
    published:    true,
    content: <<~TEXT,
      Ein unvergessliches Wochenende liegt hinter uns: Die Kalkstädter Wülfrath haben an der Deutschen Meisterschaft 2025 in Ulm teilgenommen und eine beeindruckende Vorstellung abgeliefert.

      Nach monatelanger intensiver Vorbereitung unter der Leitung von Laura Brunswig traten wir gegen Ensembles aus dem ganzen Bundesgebiet an. Die Stimmung im Orchester war ausgezeichnet – und das hat man gehört!

      Wir sind unglaublich stolz auf unsere Musikerinnen und Musiker, die diesen besonderen Moment gemeinsam erlebt haben. Ein großes Dankeschön gilt auch unseren Familien und Fans, die uns tatkräftig unterstützt haben.

      Bilder vom Wochenende findet ihr auf unserem Instagram-Kanal.
    TEXT
    image_url:  "#{BASE}/photo-1507838153414-b4b713384a76?w=900&q=80&fm=jpg",
    image_name: "deutsche-meisterschaft.jpg"
  },
  {
    title:        "Rückblick: Weihnachtskonzert 2025",
    published_at: Date.new(2025, 12, 16),
    published:    true,
    content: <<~TEXT,
      Bei stimmungsvollem Kerzenschein und vor vollem Haus präsentierten die Kalkstädter ihr diesjähriges Weihnachtskonzert im Vereinshaus.

      Das Publikum wurde mit einem bunten Mix aus klassischen Weihnachtsliedern, jazzigen Swing-Arrangements und einem mitreißenden Medley aus Filmmelodien überrascht. Als Zugabe gab es auf besonderen Wunsch noch „Last Christmas" in einer ganz eigenen Flöten-Version – die Standing Ovations sprachen für sich.

      Wir danken allen Besucherinnen und Besuchern für den schönen Abend und wünschen ein frohes Fest!
    TEXT
    image_url:  "#{BASE}/photo-1519892300165-cb5542fb47c7?w=900&q=80&fm=jpg",
    image_name: "weihnachtskonzert-rueckblick.jpg"
  },
  {
    title:        "Neue Musikschülerinnen und Musikschüler begrüßt",
    published_at: Date.new(2025, 9, 8),
    published:    true,
    content: <<~TEXT,
      Zu Beginn des neuen Musikschuljahres durften wir eine Reihe neuer Schülerinnen und Schüler in unserer vereinseigenen Musikschule willkommen heißen.

      Ob Kinder, die zum ersten Mal eine Querflöte in den Händen halten, oder Erwachsene, die sich endlich ihren Traum vom Musizieren erfüllen – der Start ist immer aufregend. Wir freuen uns auf den gemeinsamen musikalischen Weg!

      Wer sich noch anmelden möchte: Informationen findet ihr unter dem Menüpunkt Musikschule oder per Mail an info@kalkstaedter-wuelfrath.de.
    TEXT
    image_url:  "#{BASE}/photo-1598488035139-bdbb2231ce04?w=900&q=80&fm=jpg",
    image_name: "neue-musikschueler.jpg"
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

puts "Seeds fertig."
