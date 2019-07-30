class AnswerSerializer < BaseAnswerSerializer
  has_many :comments, as: :commentable
  has_many :links, as: :linkable
  has_many :files
end
