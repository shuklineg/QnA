class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question, touch: true

  validates :question, uniqueness: { scope: :user_id }
end
