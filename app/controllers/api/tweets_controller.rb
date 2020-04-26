class Api::TweetsController < Api::ApplicationController

def create
	begin
	  if current_user.present? && current_user.user_type == "NonAdminUser"
	  	tweet_data = Tweet.new(tweets_params)
		tweet_data["user_id"] = current_user.id
			if tweet_data.save
				response.header['msg'] = "Record Created Successfully."
				render json: {success:true,status_msg:"Record Created Successfully",data:ActiveModel::SerializableResource.new(tweet_data).as_json}, status: 200
			
			else
				response.header['msg'] = tweet_data.errors.full_messages.first+'.'
				render json:{success:false, status_msg:tweet_data.errors.full_messages.first+'.'} , status: 422
			end

	 	else
			response.header['msg'] = "Please login first with a valid user credentials"
			render json: {success:false,status_msg: "Please login first with a valid user credentials"} , status: 422
  		end

  	rescue Exception => e
      exception_handling(e)
    end	

end

def update
   begin
	 if current_user.present? || admin_signed_in

		if current_user.user_type == "NonAdminUser"
			tweet_data = Tweet.where(id:params[:id],user_id:current_user.id)
		else
			tweet_data = Tweet.where(id:params[:id])
		end
	
		if tweet_data.present?	
			if tweet_data.first.update(tweets_params)
				response.header['msg'] = "Record Updated Successfully."
				render json: {success:true,status_msg:"Record Updated Successfully",data:ActiveModel::SerializableResource.new(Tweet.find(tweet_data.first.id)).as_json}, status: 200
			else	
			response.header['msg'] = tweet_data.first.errors.full_messages.first+'.'
			render json:{success:false, status_msg:tweet_data.first.errors.full_messages.first+'.'} , status: 422 
			end
		else
			response.header['msg'] = "The requested Tweet is not Present"
			render json: {success:false, status_msg:"The requested Tweet is not Present"} , status: 404
		end
	 else
		response.header['msg'] = "Please login first with a valid user credentials"
		render json: {success:false,status_msg: "Please login first with a valid user credentials"} , status: 422
	 end

  rescue Exception => e
  	 exception_handling(e)
   end	
end


def destroy
	  begin
		if current_user.present? || admin_signed_in

			if current_user.user_type == "NonAdminUser"
				tweet_data = Tweet.where(id:params[:id],user_id:current_user.id)
			else
				tweet_data = Tweet.where(id:params[:id])
			end

			if tweet_data.present?	
				if tweet_data.first.delete
					response.header['msg'] = "Record Deleted Successfully."
					render json: {success:true,status_msg:"Record Deleted Successfully"}, status: 200
				end
			else
				response.header['msg'] = "The requested Tweet is not Present"
				render json: {success:false, status_msg:"The requested Tweet is not Present"} , status: 404
			end
		else
			response.header['msg'] = "Please login first with a valid user credentials"
			render json: {success:false,status_msg: "Please login first with a valid user credentials"} , status: 422
		end

	rescue Exception => e
		exception_handling(e)
	end
end


	private

	def tweets_params
		params.require(:tweet).permit(:user_id,:content)
	end 
end