namespace :dev do
  desc "TODO"
  task setup: :environment do
    puts "Cadastrando usuários..."
    users = []
    10.times do
      users << User.create!(name: Faker::Name.name)
    end
    puts "Usuários cadastrados com sucesso!"

    puts "Cadastrando mensagens..."
    10.times do
      begin
        current_user = users.sample
        current_receiver = users.sample
      end until current_user != current_receiver

      Message.create!(
        text: "Olá, meu nome é #{current_user.name}",
        user_id: current_user.id,
        send_to_id: current_receiver.id
      )
    end
    puts "Mensagens cadastradas com sucesso!"
  end
end