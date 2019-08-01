class Answer < ApplicationRecord
  include Votable
  include Commentable
  include Linkable

  belongs_to :question
  belongs_to :user
  has_one :reward

  has_many_attached :files

  validates :body, presence: true

  def best!
    return if best

    Answer.transaction do
      Answer.where(question_id: question_id, best: true).update_all(best: false)
      update!(best: true)
      update!(reward: question.reward) if question.reward
    end
  end
end
