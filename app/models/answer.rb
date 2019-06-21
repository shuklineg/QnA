class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def best!
    return if best

    Answer.where(question_id: question_id, best: true).update_all(best: false)
    update(best: true)
  end
end
