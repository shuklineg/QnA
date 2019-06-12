class AnswersController < ApplicationController
  expose :question
  expose :answers, from: :question
  expose :answer, ancestor: :question

  def create
    answer.question = question
    if answer.save
      redirect_to question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
