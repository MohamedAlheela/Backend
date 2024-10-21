class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :json
  skip_before_action :authenticate_user!

  # GET /users/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    if resource.errors.empty?
      render json: {
        status: { code: 200, message: "Email verified successfully." },
        data: resource
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "Email verification failed." },
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # POST /users/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    if successfully_sent?(resource)
      render json: {
        status: { code: 200, message: 'Confirmation instructions sent successfully.' },
        confirmation_token: resource.confirmation_token
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: 'Failed to resend confirmation instructions.' },
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
