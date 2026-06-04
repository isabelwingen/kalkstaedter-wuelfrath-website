class Admin::SiteSettingsController < Admin::BaseController
  def edit
    @musikschule_status = SiteSetting.get("musikschule_anmeldung") || "freie_plaetze"
    @ki_systemprompt = SiteSetting.get("ki_systemprompt").to_s
  end

  def update
    allowed = %w[freie_plaetze warteliste]
    value = params[:musikschule_anmeldung]
    unless allowed.include?(value)
      return redirect_to edit_admin_site_settings_path, alert: "Ungültiger Wert."
    end

    SiteSetting.set("musikschule_anmeldung", value)
    SiteSetting.set("ki_systemprompt", params[:ki_systemprompt].to_s)

    redirect_to edit_admin_site_settings_path, notice: "Einstellungen gespeichert."
  end
end
