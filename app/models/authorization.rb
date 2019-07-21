class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true

  def confirmed?
    !confirmation_token
  end

  def confirm!
    update(confirmation_token: nil)
  end
end
