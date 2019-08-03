require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let!(:old_questions) { create_list(:question, 3, :sequences, created_at: 1.day.ago) }
    let!(:current_questions) { create_list(:question, 5, :sequences) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Questions digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      current_questions.each do |question|
        expect(mail.body.encoded).to have_content(question.title)
      end

      old_questions.each do |question|
        expect(mail.body.encoded).to_not have_content(question.title)
      end
    end
  end
end
