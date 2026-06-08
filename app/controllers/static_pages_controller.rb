class StaticPagesController < ApplicationController
  allow_unauthenticated_access

  def ueber_uns
    @page_content = StaticPageContent.find_by(slug: "ueber_uns")
  end

  def mitmachen
    @page_content = StaticPageContent.find_by(slug: "mitmachen")
  end

  def musikschule
    @musikschule_status = SiteSetting.get("musikschule_anmeldung") || "freie_plaetze"
    @page_content = StaticPageContent.find_by(slug: "musikschule")
  end

  def chronik
    @page_content = StaticPageContent.find_by(slug: "chronik")
  end

  def impressum
    @page_content = StaticPageContent.find_by(slug: "impressum")
  end

  def datenschutz
    @page_content = StaticPageContent.find_by(slug: "datenschutz")
  end
end
