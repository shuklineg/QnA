class AuthorizationsPreview < ActionMailer::Preview
  def email_confirmation
    user = User.new(email: 'test@email.com')
    authorization = Authorization.new(user: user, confirmation_token: '12345')
    AuthorizationsMailer.email_confirmation(authorization)
  end
end
