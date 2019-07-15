class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments-question-#{params[:questionId]}"
  end
end
