class AuthsController < ApplicationController
  def create
    generate_token(params[:name], params[:password])
  end
end
