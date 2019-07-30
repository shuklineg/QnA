class Api::V1::QuestionsController < Api::V1::BaseController
  expose :questions, -> { Question.all }
  expose :question, scope: -> { Question.with_attached_files }

  def index
    authorize! :index, Question
    render json: questions, each_serializer: BaseQuestionSerializer
  end

  def show
    authorize! :read, question
    render json: question
  end
end
