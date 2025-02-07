module Authentication
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods

  included do
    before_action :authenticate
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      hmac_secret = ENV['JWT_SECRET'] || Rails.application.credentials.jwt_secret

      if hmac_secret.nil?
        render json: { error: "JWT secret not configured" }, status: :internal_server_error
        return
      end

      begin
        decoded_token = JWT.decode(token, hmac_secret, true, { algorithm: 'HS256' })

        @current_user_payload = decoded_token[0]
      rescue JWT::DecodeError
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  end
end