require 'rails_helper'

RSpec.describe AuthorizationsMailer, type: :mailer do
  describe 'email_confirmation' do
    let(:user) { create(:user) }
    let(:authorization) { create(:authorization, user: user, confirmation_token: '12345') }
    let(:mail) { AuthorizationsMailer.email_confirmation(authorization) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Email confirmation')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to have_link('Confirm my account', href: email_confirmation_authorization_url(confirmation_token: authorization.confirmation_token))
    end
  end
end
