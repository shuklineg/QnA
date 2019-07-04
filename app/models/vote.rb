class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, numericality: { greater_than_or_equal_to: -1, less_than_or_equal_to: 1, only_integer: true, message: "You can't vote twice" }

  validate :author_cant_vote

  def self.vote_up(user, votable)
    vote = Vote.where(user: user, votable: votable).first_or_initialize(user: user, votable: votable)
    vote.value += 1
    vote
  end

  def self.vote_down(user, votable)
    vote = Vote.where(user: user, votable: votable).first_or_initialize(user: user, votable: votable)
    vote.value -= 1
    vote
  end

  private

  def author_cant_vote
    errors.add(:user, "Author can't vote") if user&.author_of?(votable)
  end
end
