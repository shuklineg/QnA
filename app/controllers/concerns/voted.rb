module Voted
  extend ActiveSupport::Concern

  def vote_up
    votable.vote_up!(current_user)

    respond_to do |format|
      format.json do
        render json: { object_id: votable.id, value: votable.rating, model: votable.class.name.underscore }
      end
    end
  end

  def vote_down
    votable.vote_down!(current_user)

    respond_to do |format|
      format.json do
        render json: { object_id: votable.id, value: votable.rating, model: votable.class.name.underscore }
      end
    end
  end

  private

  def votable
    send(controller_name.singularize)
  end
end
