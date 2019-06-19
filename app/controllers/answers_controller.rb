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
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to answer.question, notice: 'Your answer has been deleted.'
    else
      redirect_to answer.question
    end
  end

  def update
    answer.update(answer_params)
    @question = answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
