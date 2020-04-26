Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :authorizations, :applications,
    :authorized_applications
  end
  namespace :api, defaults: {format: :json} do
		devise_for :users, skip: [:sessions,:passwords], controllers: {
			registrations: 'api/users/registrations'
			}
  resources :tweets	
  resources :passwords
  post 'forget_password', to: 'passwords#forgot_password'
  post 'reset_password', to: 'passwords#reset_password'	
  end
end
