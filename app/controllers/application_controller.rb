class ApplicationController < ActionController::API
	include ActionController::MimeResponds
	include JsonWebToken
	before_action :authenticate_user!

	respond_to :json

	before_action :set_default_response_format

	private
  
	def set_default_response_format
	  request.format = :json unless params[:format]
	end
end
