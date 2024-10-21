Rails.application.routes.draw do  
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords'
  }

  devise_scope :user do
    post 'users/password', to: 'users/passwords#create'       # Create route for password reset (send OTP)
    put 'users/password', to: 'users/passwords#update'        # Update route for password reset (reset password)
    post 'users/password/verify_otp', to: 'users/passwords#verify_otp' # Custom route for OTP verification
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
