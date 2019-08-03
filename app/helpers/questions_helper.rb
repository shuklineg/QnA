module QuestionsHelper
  def subscribe_link(question, options = {})
    subscribed = current_user.subscribed?(question)
    title = subscribed ? 'Unsubscribe' : 'Subscribe'
    link = subscribed ? unsubscribe_question_path(question) : subscribe_question_path(question)
    options.merge!(method: :post, remote: true)
    link_to(title, link, options)
  end
end
