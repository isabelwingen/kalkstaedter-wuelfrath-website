class Admin::SiteSettingsController < Admin::BaseController
  def edit
    @musikschule_status = SiteSetting.get("musikschule_anmeldung") || "freie_plaetze"
  end

  def update
    allowed = %w[freie_plaetze warteliste]
    value = params[:musikschule_anmeldung]
    if allowed.include?(value)
      SiteSetting.set("musikschule_anmeldung", value)
      redirect_to edit_admin_site_settings_path, notice: "Einstellungen gespeichert."
    else
      redirect_to edit_admin_site_settings_path, alert: "Ungültiger Wert."
    end
  end
end
