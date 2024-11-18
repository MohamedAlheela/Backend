class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :json
  skip_before_action :authenticate_user!

  # GET /users/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    if resource.errors.empty?
      # render json: {
      #   status: { code: 200, message: "Email verified successfully." },
      #   data: resource
      # }, status: :ok
      render_response_helper(message: I18n.t('users.confirmations.email_verified_successfully'), status: :ok, data: {"user": resource})
    else
      # render json: {
      #   status: { code: 422, message: "Email verification failed." },
      #   errors: resource.errors.full_messages
      # }, status: :unprocessable_entity
      render_error(message: I18n.t('users.confirmations.email_verification_failed'), status: :unprocessable_entity, error: resource.errors.full_messages)
    end
  end

  # POST /users/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    if successfully_sent?(resource)
      # render json: {
      #   status: { code: 200, message: 'Confirmation instructions sent successfully.' },
      #   confirmation_token: resource.confirmation_token
      # }, status: :ok
      render_response_helper(message: I18n.t('users.confirmations.confirmation_instructions_sent_successfully'), status: :ok, data: {"user": resource}, extra: {"confirmation_token": resource.confirmation_token})
    else
      # render json: {
      #   status: { code: 422, message: 'Failed to resend confirmation instructions.' },
      #   errors: resource.errors.full_messages
      # }, status: :unprocessable_entity
      render_error(message: I18n.t('users.confirmations.failed_to_resend_confirmation_instructions'), status: :unprocessable_entity, error: resource.errors.full_messages)
    end
  end
end
