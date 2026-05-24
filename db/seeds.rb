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
  },
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
  },
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
