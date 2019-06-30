class RewardsController < ApplicationController
  expose :user
  expose :rewards, -> { user.rewards }

  def index; end
end
