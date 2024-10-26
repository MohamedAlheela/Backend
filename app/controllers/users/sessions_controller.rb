class Users::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :authenticate_user!, only: :create
  skip_before_action :verify_signed_out_user, only: :destroy

  # POST /users/sign_in
  def create
    user = User.find_by(email: params[:user][:email])
    if user && user.valid_password?(params[:user][:password])
      token = JwtService.encode(user_id: user.id)
      # render json: { message: 'Logged in successfully', }, status: :ok
      render_response_helper(message: I18n.t('users.sessions.success') , data: {"user": user}, extra: {"access_token": token}, status: :ok)
    else
      # render json: { errors: 'Invalid email or password' }, status: :unprocessable_entity
      render_error(message: I18n.t('users.sessions.error'), status: :unprocessable_entity, error: I18n.t('users.sessions.error'))
    end
  end

  # DELETE /users/sign_out
  def destroy
    if request.headers['Authorization'].present?
      token = request.headers['Authorization'].split(' ').last
      jwt_payload = JwtService.decode(token)

      user = User.find_by(id: jwt_payload['user_id'])
      if user
        sign_out(user)
        # render json: { message: 'Logged out successfully' }, status: :ok
        render_response_helper(message: I18n.t('users.sessions.success'), status: :ok)
      else
        # render json: { errors: 'Invalid token or user not found' }, status: :unauthorized
        render_error(message: I18n.t('users.sessions.invalid_token'), status: :unauthorized, error: I18n.t('users.sessions.invalid_token'))
      end
    else
      # render json: { errors: 'Authorization header missing' }, status: :unprocessable_entity
      render_error(message: I18n.t('auth_is_missing'), status: :unprocessable_entity, error:  I18n.t('auth_is_missing'))
    end
  end
end
