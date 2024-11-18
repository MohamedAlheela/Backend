class Users::PasswordsController < Devise::PasswordsController
  respond_to :json
  skip_before_action :authenticate_user!

  # POST /users/password
  def create
    self.resource = resource_class.find_by(email: resource_params[:email])
    
    if resource
      # Generate OTP
      otp = generate_otp
      # Store OTP (you might want to save it in the user's record or send it via email)
      resource.update(otp: otp, otp_sent_at: Time.now.utc)
      
      # Send OTP via email (you might have a mailer for this)
      UserMailer.send_otp(resource.email, otp).deliver_now
      
      # render json: {
      #   status: { code: 200, message: "OTP sent successfully." },
      #   otp: otp
      # }, status: :ok
      render_response_helper(message: I18n.t('users.passwords.otp_sent_successfully'), status: :ok, extra: {"otp": otp})
    else
      # render json: {
      #   status: { code: 422, message: "Email not found." }
      # }, status: :unprocessable_entity
      render_error(message: I18n.t('users.passwords.email_not_found'), status: :unprocessable_entity)
    end
  end

  # POST /users/password/verify_otp
  def verify_otp
    self.resource = resource_class.find_by(email: resource_params[:email])
    
    if resource && valid_otp?(resource, resource_params[:otp])
      # render json: {
      #   status: { code: 200, message: "OTP verified successfully." }
      # }, status: :ok
      render_response_helper(message: I18n.t('users.passwords.otp_verified_successfully'), status: :ok)
    else
      # render json: {
      #   status: { code: 422, message: "Invalid OTP." }
      # }, status: :unprocessable_entity
      render_error(message: I18n.t('users.passwords.invalid_otp'), status: :unprocessable_entity)
    end
  end

  # PUT /users/password
  def update
    self.resource = resource_class.find_by(email: resource_params[:email])
    
    if resource && valid_otp?(resource, resource_params[:otp])
      resource.reset_password(resource_params[:password], resource_params[:password_confirmation])
      if resource.errors.empty?
        # render json: {
        #   status: { code: 200, message: "Password reset successfully." },
        #   data: resource
        # }, status: :ok
        render_response_helper(message: I18n.t('users.passwords.password_reset_successfully'), status: :ok, data: {"user": resource})
      else
        # render json: {
        #   status: { code: 422, message: "Password reset failed." },
        #   errors: resource.errors.full_messages
        # }, status: :unprocessable_entity
        render_error(message: I18n.t('users.passwords.password_reset_failed'), status: :unprocessable_entity, error: resource.errors.full_messages)
      end
    else
      # render json: {
      #   status: { code: 422, message: "Email not found or invalid OTP." }
      # }, status: :unprocessable_entity
      render_error(message: I18n.t('users.passwords.email_not_found_or_invalid_otp'), status: :unprocessable_entity)
    end
  end

  private

  def generate_otp
    rand(100000..999999).to_s # Generate a random 6-digit OTP
  end

  def valid_otp?(user, otp)
    # Check if the OTP is correct and not expired (you can implement expiration logic)
    user.otp == otp && (Time.now.utc - user.otp_sent_at) < 10.minutes
  end
end
