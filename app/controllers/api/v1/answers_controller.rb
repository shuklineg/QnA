class Api::V1::AnswersController < Api::V1::BaseController
  expose :answers, from: :question
  expose :answer, scope: -> { Answer.with_attached_files }

  def index
    authorize! :index, Answer
    render json: answers, each_serializer: BaseAnswerSerializer
  end

  def show
    authorize! :read, answer
    render json: answer
  end

  private

  def question
    Question.find_by(id: params[:question_id]) || answer.question
  end
end
