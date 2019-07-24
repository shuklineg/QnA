class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js { render params[:action], status: :unauthorized }
      format.json { render json: {}, status: :unauthorized }
    end
  end

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
