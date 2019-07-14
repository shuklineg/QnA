class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  after_action :publish_question, only: :create

  expose :questions, -> { Question.all }
  expose :question, scope: -> { Question.with_attached_files }
  expose :answers, from: :question
  expose :answer, -> { Answer.new }
  expose :comment, -> { question.comments.new }

  def show
    answer.links.new
  end

  def new
    question.links.new
    question.build_reward
  end

  def create
    question.user = current_user
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      question.build_reward unless question.reward
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

  private

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      question: question,
      links: question.links,
      files: question.files.map { |file| { id: file.id, name: file.filename.to_s, url: url_for(file) } }
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy], reward_attributes: [:image, :name])
  end
end
