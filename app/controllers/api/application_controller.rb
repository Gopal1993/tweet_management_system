class Api::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :doorkeeper_authorize!

  before_action :configure_permitted_parameters, if: :devise_controller?

  respond_to :json

  

  def current_user
    @devise_current_user || User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def devise_current_user
    if session && session['warden.user.user.key']
      @devise_current_user = User.find_by(id: session['warden.user.user.key'][0][0])
    end
  end



  protected

  # Devise methods
  # Authentication key(:username) and password field will be added automatically by devise.
  def configure_permitted_parameters
    added_attrs = [:email, :password,:name,:user_type]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

   def exception_handling(e)
    logger.error "exception_handling: #{e}"
    status = e.http_status rescue 404
    headers['msg'] = e.message
    render json: {status: status, :success => false, :status_msg => e.message}
  end

  def admin_signed_in
    if current_user.present? && current_user.user_type == "AdminUser"
      return true
    else
      return false
    end
  end

  private

  # Doorkeeper methods
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

end