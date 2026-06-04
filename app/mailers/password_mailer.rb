class PasswordMailer < ApplicationMailer
  def reset(user)
    @user = user
    @reset_url = edit_password_url(user.generate_token_for(:password_reset))
    mail to: user.email_address, subject: "Passwort zurücksetzen"
  end
end
