class CommentsController < ApplicationController
  before_action :set_commentable, only: :create
  before_action :authenticate_user!

  expose :comment

  def create
    @commentable.comments << comment
    comment.user = current_user
    comment.save
  end

  private

  def set_commentable
    @resource, @resource_id = request.path.split('/')[1, 2]
    @resource = @resource.singularize
    @commentable = @resource.singularize.classify.constantize.find(@resource_id)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
