class Reward < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true
  validate :attached_image

  private

  def attached_image
    errors.add(:image, 'You must add an image file.') unless image.attached?
  end
end
