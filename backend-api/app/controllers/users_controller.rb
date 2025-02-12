class UsersController < ApplicationController
  include Authentication
  before_action :set_user, only: %i[ show update destroy ]
  before_action :authenticate_user, only: [:index, :show, :update, :destroy, :find_by_name]

  def index
    @users = User.all

    render json: @users
  end

  def show
    render json: @user
  end

  def find_by_name
    user = User.find_by(name: params[:name])

    if user
      render json: user
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def create
    @user = User.new
    @user.name = params[:name]
    @user.password = params[:password]

    if User.exists?(name: params[:name])
      @user.errors.add(:name, "already exists")
      render json: @user.errors, status: :unprocessable_entity

    elsif @user.save
      generate_token(params[:name], params[:password])
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
  end

  private

    def set_user
      @user = User.find(params.expect(:id))
    end

    def user_params
      params.require(:user).permit(:name, :password)
    end
end
