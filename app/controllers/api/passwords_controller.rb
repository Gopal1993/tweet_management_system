class Api::PasswordsController < Api::ApplicationController
skip_before_action :doorkeeper_authorize!
	def forgot_password
		begin	
		 	
		  if !params[:email].present? 
			response.header['msg'] = "Email not present."
		    render json: {success:false,success_msg:"Email not present"},status:422
		  end
		  user = User.find_by(email:params[:email])

		  if user.present?
			  user.generate_password_token! 

			  response.header['msg'] = "password token generated successfully."
			  render json: {success:true,success_msg:"password token generated successfully",password_token:User.find_by(email:params[:email]).reset_password_token},status:200
		  else
		  	response.header['msg'] = "Email address not found. Please check and try again."
		  	render json: {success:false, success_msg:"Email address not found. Please check and try again."}, status:422
		  end

		rescue Exception => e
		  exception_handling(e)
		end	

    end



  def reset_password
   begin
    new_password_token = params[:token].to_s

    if !params[:email].present?
      response.header['msg'] = "Password cannot be changed without valid Token."
      render json: {success:false,success_msg:"Password cannot be changed without valid Token."},status: 422
    end

    user = User.find_by(reset_password_token: new_password_token)

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
      	response.header['msg'] = "Password reset successfully."
        render json: {success:true,success_msg:"Password reset successfully"}, status:200
      else

      	response.header['msg'] = user.errors.full_messages.first+'.'
		render json:{success:false, status_msg:user.errors.full_messages.first+'.'},  status:422
      end
    else
    	response.header['msg'] = "Password reset link is not valid or may be expired,please try again sometime later."
      render json: {success:false,status_msg:"Password reset link is not valid or may be expired,please try again sometime later."}, status:422
    end
	rescue Exception => e
	  exception_handling(e)
	end	
  end


end