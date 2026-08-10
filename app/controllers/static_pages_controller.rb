class StaticPagesController < ApplicationController
  allow_unauthenticated_access

  def ueber_uns; end
  def mitmachen; end
  def musikschule
    @musikschule_status = SiteSetting.get("musikschule_anmeldung") || "freie_plaetze"
  end
  def impressum; end
  def datenschutz; end
  def barrierefreiheit; end
end
