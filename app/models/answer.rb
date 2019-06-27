class Answer < ApplicationRecord
  has_many :links, as: :linkable, dependent: :destroy
  belongs_to :question
  belongs_to :user

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :body, presence: true

  def best!
    return if best

    Answer.transaction do
      Answer.where(question_id: question_id, best: true).update_all(best: false)
      update!(best: true)
    end
  end

  def best?
    best
  end
end
