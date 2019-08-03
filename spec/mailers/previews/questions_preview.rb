# Preview all emails at http://localhost:3000/rails/mailers/questions
class QuestionsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/questions/subscription
  def subscription
    user = User.new(email: 'test@email.com')
    answer = Answer.new(body: 'Ansewer body')
    question = Question.new(title: 'Question title', body: 'Question body', answers: [answer])
    QuestionsMailer.subscription(user, question, answer)
  end

end
