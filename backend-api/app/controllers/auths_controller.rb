class AuthsController < ApplicationController
  def create
    hmac_secret = ENV['JWT_SECRET'] || Rails.application.credentials.jwt_secret
    payload = params[:user_id]

    token = JWT.encode(payload, hmac_secret, 'HS256')
    render json: { token: token }
  end
end
