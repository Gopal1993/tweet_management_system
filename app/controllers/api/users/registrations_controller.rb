class Api::Users::RegistrationsController < Devise::RegistrationsController
   protect_from_forgery with: :null_session
   before_action :configure_permitted_parameters, if: :devise_controller?
   respond_to :json
   

  # POST /resource
  def create
    build_resource(sign_up_params)
     resource.save
    if resource.save
      response.header['msg'] = "Data Inserted Successfully."
      render json: 
      {success: true,status_msg:"Data Inserted Successfully",user_data:ActiveModel::SerializableResource.new(resource).as_json} , status: 200
    else
      response.header['msg'] = resource.errors.full_messages.first+'.'
      render json: {success: false ,status_msg:resource.errors.full_messages.first+'.'} , status: 422
    end
  end

 


  protected

  def configure_permitted_parameters
    added_attrs = [:name, :email, :user_type,:password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

private

 def sign_up_params
    params.require(:user).permit(:name,:password,:email,:user_type)
 end 

end
