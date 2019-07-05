class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, inclusion: { in: [-1, 1], message: "You can't vote twice" }

  validate :author_cant_vote

  def self.vote_up(user, votable)
    vote = Vote.where(user: user, votable: votable).find_or_initialize_by(user: user, votable: votable)
    vote.value += 1
    destroy_if_revote(vote)
  end

  def self.vote_down(user, votable)
    vote = Vote.where(user: user, votable: votable).find_or_initialize_by(user: user, votable: votable)
    vote.value -= 1
    destroy_if_revote(vote)
  end

  def self.destroy_if_revote(vote)
    return vote unless vote.value.zero?

    vote.destroy
    nil
  end

  private_class_method :destroy_if_revote

  private

  def author_cant_vote
    errors.add(:user, "Author can't vote") if user&.author_of?(votable)
  end
end
