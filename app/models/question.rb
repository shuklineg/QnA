class Question < ApplicationRecord
  include Votable
  include Commentable
  include Linkable

  has_many :answers, -> { order(best: :desc, id: :asc) }, dependent: :destroy
  has_one :reward, dependent: :destroy
  has_and_belongs_to_many :subscribed_users, class_name: 'User'
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  before_create :subscribe_author

  private

  def subscribe_author
    subscribed_users << user
  end
end
