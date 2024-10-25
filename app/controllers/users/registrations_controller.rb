class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  # POST /users
  def create
    build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      # Send confirmation email
      # UserMailer.confirmation_email(resource).deliver_now
      # Devise::Mailer.confirmation_instructions(@user, @token).deliver_now

      if resource.active_for_authentication?
        # Return the confirmation token in the response
        render json: {
          status: { code: 200, message: 'Signed up successfully.' },
          data: resource,
          confirmation_token: resource.confirmation_token
        }, status: :ok
      else
        # This will be the case when `confirmable` is used and the user needs to confirm their email
        render json: {
          status: { code: 200, message: 'Signed up successfully. Please confirm your email.' },
          data: resource,
          confirmation_token: resource.confirmation_token
        }, status: :ok
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: {
        status: { code: 422, message: 'Sign-up failed.' },
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :photo, :type, :latitude, :longitude, :address])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :photo, :type, :latitude, :longitude, :address])
  end
end
