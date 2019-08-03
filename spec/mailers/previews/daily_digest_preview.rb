class DailyDigestPreview < ActionMailer::Preview
  def digest
    user = User.new(email: 'test@email.com')
    DailyDigestMailer.digest(user)
  end
end
