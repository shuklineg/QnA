class Question < ApplicationRecord
  include Votable
  include Commentable
  include Linkable

  default_scope { order(id: :asc) }

  has_many :answers, -> { order(best: :desc, id: :asc) }, dependent: :destroy
  has_one :reward, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_users, through: :subscriptions, source: :user
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :subscribe_author

  private

  def subscribe_author
    Subscription.create!(question: self, user: user)
  end
end
