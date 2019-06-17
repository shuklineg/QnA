class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :question
  expose :answers, from: :question
  expose :answer, ancestor: :question

  def create
    answer.question = question
    if answer.save
      redirect_to question, notice: 'Answer successfully created.'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
