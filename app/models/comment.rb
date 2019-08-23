class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, presence: true

  default_scope { order(id: :asc) }
end
