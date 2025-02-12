class MessageSaverJob
  include Sidekiq::Job

  def perform(message_data)
    message = Message.new(message_data)

    if message.save
      Rails.logger.info "Mensagem salva com sucesso: #{message.inspect}"
    else
      Rails.logger.error "Erro ao salvar mensagem: #{message.errors.full_messages}"
    end
  end
end
