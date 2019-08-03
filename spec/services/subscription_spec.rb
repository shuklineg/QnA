require 'rails_helper'

RSpec.describe Services::QuestionSubscription do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscribed_user) { create(:user, subscriptions: [question]) }
  let!(:unsubscribed_user) { create(:user) }

  it 'sends answer to all subscribed users' do
    expect(QuestionsMailer).to receive(:subscription).with(subscribed_user, question, answer).and_call_original
    expect(QuestionsMailer).to receive(:subscription).with(question.user, question, answer).and_call_original
    expect(QuestionsMailer).to_not receive(:subscription).with(unsubscribed_user, question, answer).and_call_original
    subject.send_subscription(answer)
  end
end
