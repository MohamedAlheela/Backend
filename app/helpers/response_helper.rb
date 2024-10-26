# frozen_string_literal: true

module ResponseHelper
  
    def render_response_helper(message: I18n.t("success"), status: :ok, data: {}, extra: {})
      response_hash = {message: message, data: data}
      extra = extra.merge(@pagination_info) if @pagination_info.present?
      response_hash = response_hash.merge(extra: extra) if extra.present?
      render json: response_hash, status: status 
    end
  
    def render_error(error: "", message: "", status: :unprocessable_entity, data: {}, backtrace: nil, error_type: nil, unhandled: false)
      response = {error: error, message: message}
      response[:data] = data if data.present?
      response[:exception_type] = error_type if error_type.present?
      response[:unhandled_exception] = true if unhandled
      response[:backtrace] = backtrace if backtrace.present?
      # respond_to do |format|
      render json: response, status: status 
        # format.xml { render xml: response.to_xml, status: status }
      # end
    end
  
    def render_bad_request_response(message: I18n.t("errors.bad_request"), error: "BAD_REQUEST", status: :bad_request, invalid_parameter: nil, allowed_values: nil)
      response = {error: error, message: message}
      response[:invalid_parameter] = invalid_parameter if invalid_parameter.present?
      response[:allowed_values] = allowed_values.is_a?(Array) ? allowed_values : [allowed_values] if allowed_values.present?
      respond_to do |format|
        format.json { render json: response, status: status }
        format.xml { render xml: response.to_xml, status: status }
      end
    end
  
    def serializer_options(full_details: false, include: [], is_owner: false)
      {params: {full_details: full_details, current_user: @current_user, include: include, is_owner: is_owner}}
    end
  end
  