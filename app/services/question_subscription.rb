class Services::QuestionSubscription
  def send_subscription(answer)
    question = answer.question
    question.subscribed_users.find_each(batch_size: 500) do |user|
      QuestionsMailer.subscription(user, question, answer).deliver_later
    end
  end
end
