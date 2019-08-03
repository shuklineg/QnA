require 'rails_helper'

RSpec.describe QuestionsMailer, type: :mailer do
  describe 'subscription' do
    let(:user) { create(:user) }
    let(:question) { create(:question, subscribed_users: [user]) }
    let!(:answer) { create(:answer, question: question) }
    let(:mail) { QuestionsMailer.subscription(user, question, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Subscription')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to have_content(question.title)
      expect(mail.body.encoded).to have_content(answer.body)
    end
  end
end
