class Question < ApplicationRecord
  include Votable
  include Commentable
  include Linkable

  has_many :answers, -> { order(best: :desc, id: :asc) }, dependent: :destroy
  has_one :reward, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
end
