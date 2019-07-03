module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up!(user)
    return if user.author_of? self

    vote = Vote.where(user: user, votable: self).first_or_initialize(user: user, votable: self)
    vote.value += 1
    vote.save!
  end
end
