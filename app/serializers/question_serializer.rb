class QuestionSerializer < BaseQuestionSerializer
  has_many :comments, as: :commentable
  has_many :links, as: :linkable
  has_many :files
end
