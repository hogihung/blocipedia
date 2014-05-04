class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def after_sign_in_path_for(resource)
    wikis_path
  end

  def permission_denied
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
  end

end
