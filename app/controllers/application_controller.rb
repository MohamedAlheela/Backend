class ApplicationController < ActionController::API
	include ActionController::MimeResponds
	include ResponseHelper
	include JsonWebToken

	before_action :authenticate_user!

	respond_to :json

	before_action :set_default_response_format	
	
	private
  
	def set_default_response_format
	  request.format = :json unless params[:format]
	end

	def render_response(model_name:, data: {}, message: 'Success', status: :ok, extra: {})
		# Dynamically get the serializer class based on the model name
		serializer_class = "#{model_name}Serializer".safe_constantize if model_name.present?
		
		# Serialize the data if the serializer class and data are present
		if serializer_class.present? && data.present?
			serialized_data = serializer_class.new(data).serializable_hash
			# Extract attributes and ID, then wrap them in a hash with the model name as the key
			wrapped_data = {
				model_name.downcase => serialized_data[:data][:attributes].merge(id: serialized_data[:data][:id])
			}
		else
			# Set wrapped_data to an empty hash if no data or serializer
			wrapped_data = {}
		end
		
		# Check if the data includes pagination info, and merge with extra if so
		if data.respond_to?(:total_pages)
			extra.merge!(
				total_pages: data.total_pages,
				current_page: data.current_page,
				next_page: data.next_page,
				prev_page: data.prev_page,
				total_count: data.total_count
			)
		end
	
		render json: {
			message: message,
			data: wrapped_data,
			extra: extra
		}, status: status
	end

	def handle_error(exception, message, status: :unprocessable_entity)
    Rails.logger.error(exception.message) # Log the error for debugging
    render_response(data: { errors: exception.record.errors.full_messages }, message: message, status: status)
  end

	def paginate(collection)
    page = params[:page] || 1
    per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : Kaminari.config.default_per_page

    collection.page(page).per(per_page)
  end

	def authorize_customer_or_admin
    unless %w[customer admin].include?(@current_user.role)
      render_response(message: I18n.t('errors.unauthorized_customer_admin'), status: :forbidden)
    end
  end

	def authorize_admin
    unless @current_user.admin?
      render_response(message: I18n.t('errors.unauthorized_admin'), status: :forbidden)
    end
  end
end
