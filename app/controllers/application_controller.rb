class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to new_user_session_path
  end
end
