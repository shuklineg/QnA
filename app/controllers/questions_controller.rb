class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question, scope: -> { Question.with_attached_files }
  expose :answers, from: :question
  expose :answer, -> { question.answers.new }

  def create
    question.user = current_user
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author_of?(question)
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question has been deleted.'
    else
      redirect_to question
    end
  end

  def delete_file
    return unless current_user.author_of?(question)

    @file = question.files.find(params[:file_id])
    @file.purge
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
