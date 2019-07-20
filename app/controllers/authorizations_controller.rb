# frozen_string_literal: true

class AuthorizationsController < ApplicationController
  before_action :filter_session, only: %i[new create]
  before_action :find_user, only: %i[create]

  def new
    @user = User.new
  end

  def create
    if @user.new_record? && !@user.generate_password.save
      render :new
    else
      @user.create_authorization(OmniAuth::AuthHash.new(session[:omniauth]))
      session.delete(:omniauth)
      redirect_to root_path, notice: 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
    end
  end

  def email_confirmation; end

  private

  def filter_session
    redirect_to root_path unless session[:omniauth]
  end

  def find_user
    @user = User.find_or_create_by(email: authorization_params[:email])
  end

  def authorization_params
    params.require(:user).permit(:email)
  end
end
