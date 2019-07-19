# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :filter_session, only: %i[new_auth create_auth]

  def new_auth
    @user = User.new
  end

  def create_auth
    password = Devise.friendly_token[0, 20]
    @user = User.create(sign_up_params.merge(password: password, password_confirmation: password))
    if @user.errors.any?
      render :new_auth
    else
      @user.create_authorization(OmniAuth::AuthHash.new(session[:omniauth]))
      session.delete(:omniauth)
      redirect_to root_path, notice: 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
    end
  end

  private

  def filter_session
    redirect_to root_path unless session[:omniauth]
  end
end
