require 'rails_helper'

RSpec.describe Services::QuestionSubscription do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscribed_user) { create(:user) }
  let!(:subscription) { create(:subscription, user: subscribed_user, question: question) }
  let!(:unsubscribed_user) { create(:user) }
  let(:mailer) { double('QuestionsMailer') }

  it 'sends answer to all subscribed users' do
    expect(QuestionsMailer).to receive(:subscription).with(subscribed_user, question, answer).and_call_original
    expect(QuestionsMailer).to receive(:subscription).with(question.user, question, answer).and_call_original

    subject.send_subscription(answer)
  end

  it 'does not sends answer to unsubscribed users' do
    expect(mailer).to_not receive(:subscription).with(unsubscribed_user, question, answer)

    subject.send_subscription(answer)
  end
end
