class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable

  validates :body, presence: true

  default_scope { order(id: :asc) }
end
