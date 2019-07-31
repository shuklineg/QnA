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

  def destroy
    authorize! :destroy, answer
    answer.destroy
  end

  def create
    authorize! :create, Answer
    answer.user = current_resource_owner
    answer.question = question
    answer.save ? head(:ok) : head(422)
  end

  def update
    authorize! :update, answer
    answer.update(answer_params) ? head(:ok) : head(422)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    Question.find_by(id: params[:question_id]) || answer.question
  end
end
