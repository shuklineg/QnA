class RewardsController < ApplicationController
  expose :user
  expose :rewards, -> { user.rewards }

  def index
    authorize! :index, Reward
  end
end
