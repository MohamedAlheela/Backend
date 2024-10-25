module JsonWebToken
  extend ActiveSupport::Concern

  def authenticate_user!
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    decoded = JwtService.decode(header)
    @current_user = User.find_by(id: decoded[:user_id])
  rescue
    render json: { errors: 'Unauthorized' }, status: :unauthorized
  end
end
