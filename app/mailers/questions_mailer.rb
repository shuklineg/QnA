class QuestionsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.questions_mailer.subscription.subject
  #
  def subscription(user, question, answer)
    @question = question
    @answer = answer

    mail to: user.email
  end
end
