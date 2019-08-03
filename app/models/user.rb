class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, through: :answers
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_and_belongs_to_many :subscriptions, class_name: 'Question'

  def author_of?(resource)
    resource&.user_id == id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def create_unconfirmed_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid, confirmation_token: Devise.friendly_token)
  end

  def generate_password
    new_password = Devise.friendly_token
    self.password = self.password_confirmation = new_password
    self
  end

  def auth_confirmed?(auth)
    auth && authorizations.find_by(uid: auth.uid, provider: auth.provider)&.confirmed?
  end

  def subscribe(question)
    subscriptions << question
    save!
  end

  def subscribed?(question)
    subscriptions.include?(question)
  end
end
