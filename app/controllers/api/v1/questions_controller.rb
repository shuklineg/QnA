class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    authorize! :index, Question
    @questions = Question.all
    render json: @questions, each_serializer: BaseQuestionSerializer
  end

  def show
    @question = Question.with_attached_files.find(params[:id])
    render json: @question
    authorize! :read, @question
  end
end
