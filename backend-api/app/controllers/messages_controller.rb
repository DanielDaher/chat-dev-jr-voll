class MessagesController < ApplicationController
  include Authentication
  before_action :set_message, only: %i[ update destroy ]
  before_action :authenticate_user

  def by_user
    user_id = params[:user_id]
    send_to_id = params[:send_to_id]
    per_page = params.dig(:size, :number)&.to_i || 30
    page_number = params.dig(:page, :number)&.to_i || 1
    skip = (page_number - 1) * per_page
    
    return unless validate_user_id(user_id)

    if send_to_id.present?
      @messages = get_only_with_user_and_send_to_id(user_id, send_to_id, skip, per_page)
    else
      @messages = get_all_with_user_id(user_id, send_to_id, skip, per_page)
    end
  
    render json: @messages.reverse
  end

  def find_contacts
    current_user_id = @current_user_payload["user_id"]
    @user = User.find(current_user_id)

    @interacted_users = @user.interacted_with_users

    render json: @interacted_users
  end

  def create
    user_id = params[:user_id]
    return unless validate_user_id(user_id)

    message_data = {
      text: params[:text],
      user_id: user_id,
      send_to_id: params[:send_to_id],
      is_media: params[:is_media]
    }

    @message = MessageSaverJob.perform_async(message_data)

    user = User.find_by(id: user_id)
    send_to = User.find_by(id: params[:send_to_id])

    render json: message_data.merge(
      user: user&.as_json(only: [:id, :name]),
      send_to: send_to&.as_json(only: [:id, :name, :email])
    )
  end

  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @message.destroy!
  end

  private
    def set_message
      @message = Message.find(params.expect(:id))
    end

    def message_params
      params.require(:message).permit(:text, :user_id, :name, :send_to_id, :is_media)
    end

    def validate_user_id(user_id_param)
      return false if user_id_param.nil?

      current_user_id = user_id_param.to_i
      
      unless @current_user_payload["user_id"] == current_user_id
        render json: { error: 'Forbidden' }, status: :forbidden
        return false
      end

      true
    end

    def get_all_with_user_id(user_id, send_to_id, skip, per_page)
      messages_from_user_id = Message.where(user_id: user_id)
        .order(created_at: :desc)
        .offset(skip)
        .limit(per_page)

      messages_to_user_id = Message.where(send_to_id: user_id)
        .order(created_at: :desc)
        .offset(skip)
        .limit(per_page)

      current_messages = messages_from_user_id.or(messages_to_user_id)
  
      return current_messages
    end

    def get_only_with_user_and_send_to_id(user_id, send_to_id, skip, per_page)
      messages_to_user_id = Message.where(user_id: send_to_id, send_to_id: user_id)
        .order(created_at: :desc)
        .offset(skip)
        .limit(per_page)

      messages_from_user_id = Message.where(user_id: user_id, send_to_id: send_to_id)
        .order(created_at: :desc)
        .offset(skip)
        .limit(per_page)

      current_messages = messages_from_user_id.or(messages_to_user_id)
  
      return current_messages
    end
end
