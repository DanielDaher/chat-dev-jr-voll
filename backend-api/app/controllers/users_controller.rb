class UsersController < ApplicationController
  include Authentication
  before_action :set_user, only: %i[ show update destroy ]
  before_action :authenticate_user, only: [:index, :show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
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

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :password)
    end
end
