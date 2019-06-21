class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :question
  expose :answers, from: :question
  expose :answer

  def create
    answer.question = question
    answer.user = current_user
    answer.save
  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
    @question = answer.question
  end

  def best
    answer.best! if current_user.author_of?(answer.question)
    redirect_to answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
