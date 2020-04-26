module CustomTokenResponse
    def body
        user_details = User.find(@token.resource_owner_id)
        data = super.merge({user_details: ActiveModelSerializers::SerializableResource.new(user_details, root: 'user')})
        # call original `#body` method and merge its result with the additional data hash
           {
               status_code: 200,
               status: true,
               message: I18n.t('devise.sessions.signed_in'),
               result: data
           }
    end
end