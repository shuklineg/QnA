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

  def destroy
    authorize! :destroy, question
    question.destroy
  end

  def create
    authorize! :create, Question
    question.user = current_resource_owner
    question.save ? head(:ok) : head(422)
  end

  def update
    authorize! :update, question
    question.update(question_params) ? head(:ok) : head(422)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
