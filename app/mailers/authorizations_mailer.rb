class AuthorizationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.authorizations_mailer.email_confirmation.subject
  #
  def email_confirmation(authorization)
    @email = authorization.user.email
    @token = authorization.confirmation_token
    mail to: @email
  end
end
