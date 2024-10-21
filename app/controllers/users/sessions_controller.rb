class Users::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :authenticate_user!, only: :create
  skip_before_action :verify_signed_out_user, only: :destroy

  # POST /users/sign_in
  def create
    user = User.find_by(email: params[:user][:email])
    if user && user.valid_password?(params[:user][:password])
      token = JwtService.encode(user_id: user.id)
      render json: { token: token, message: 'Logged in successfully' }, status: :ok
    else
      render json: { errors: 'Invalid email or password' }, status: :unprocessable_entity
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
        render json: { message: 'Logged out successfully' }, status: :ok
      else
        render json: { errors: 'Invalid token or user not found' }, status: :unauthorized
      end
    else
      render json: { errors: 'Authorization header missing' }, status: :unprocessable_entity
    end
  end
end
