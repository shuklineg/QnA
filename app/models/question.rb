class Question < ApplicationRecord
  has_many :answers, -> { order(best: :desc) }, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
end
