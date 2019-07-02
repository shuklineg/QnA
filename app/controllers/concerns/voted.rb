module Voted
  extend ActiveSupport::Concern

  def vote_up
    votable.vote_up!(current_user)

    respond_to do |format|
      if votable.save
        format.json do
          render json: { object_id: votable.id, value: votable.votes.count, model: votable.class.name.underscore }
        end
      else
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end

  private

  def votable
    send(controller_name.singularize)
  end
end
