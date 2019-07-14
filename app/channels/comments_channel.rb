class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments-#{params[:commentable]}-#{params[:id]}"
  end
end
