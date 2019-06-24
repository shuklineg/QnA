class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  helper_method :question

  expose :answers, from: :question
  expose :answer, scope: -> { Answer.with_attached_files }

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
  end

  def best
    answer.best! if current_user.author_of?(question)
  end

  def delete_file
    if current_user.author_of?(answer)
      @file = answer.files.find(params[:file_id])
      @file.purge
    end
  end

  private

  def question
    Question.find_by(id: params[:question_id]) || answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
