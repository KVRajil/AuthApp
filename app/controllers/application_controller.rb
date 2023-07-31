class ApplicationController < ActionController::API
  rescue_from Exception, with: :handle_exception
  rescue_from Apipie::ParamInvalid, with: :handle_param_error
  rescue_from Apipie::ParamMissing, with: :handle_param_error

  def authenticate
    @current_user = User.find_by(id: decoded_token['user_id']) if decoded_token
    if @current_user&.is_two_factor_enabled
      render json: { error: 'Unauthorized' }, status: :unauthorized unless decoded_token['otp_verified']
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    end
    return unless @current_user && @current_user.email_confirmed_at.nil?

    render json: { error: 'Email confirmation is pending' }, status: :unauthorized
  end

  def authenticate_with_password
    @current_user = User.find_by(id: decoded_token['user_id']) if decoded_token
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  attr_reader :current_user

  def decoded_token
    @decoded_token ||= JwtService.decode(auth_token)
  end

  def auth_token
    request.headers['Authorization']&.split(' ')&.last
  end

  def handle_exception
    code = 500
    title = 'generic_error'
    message = $ERROR_INFO.message
    render(json: { error: { message: message, code: code, title: title } }, status: :internal_server_error) && return
  end

  def handle_param_error
    code = 422
    title = $ERROR_INFO.message
    message = $ERROR_INFO.message
    render(json: { error: { message: message, code: code, title: title } }, status: :unprocessable_entity) && return
  end
end
