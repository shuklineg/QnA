class CommentsController < ApplicationController
  before_action :set_commentable, only: :create
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  expose :comment

  def create
    authorize! :create, Comment
    @commentable.comments << comment
    comment.user = current_user
    comment.save
  end

  private

  def set_commentable
    @resource, @resource_id = request.path.split('/')[1, 2]
    @resource = @resource.singularize
    @commentable = @resource.classify.constantize.find(@resource_id)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if comment.errors.any?

    question_id = @commentable.class == Question ? @commentable.id : @commentable.question_id

    ActionCable.server.broadcast(
      "comments-question-#{question_id}",
      comment: comment,
      user: comment.user
    )
  end
end
