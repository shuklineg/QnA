class SubscriptionsController < ApplicationController
  expose :subscription, build_params: -> { { question_id: params[:question_id], user_id: current_user&.id } }

  helper_method :question

  def create
    authorize! :create, Subscription
    subscription.save
  end

  def destroy
    authorize! :destroy, subscription
    subscription.destroy
  end

  private

  def question
    Question.find_by(id: params[:question_id]) || subscription.question
  end
end
