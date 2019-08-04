class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :question, uniqueness: { scope: :user_id }
end
