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
      current_user = users.sample
      Message.create!(
        text: "Olá, meu nome é #{current_user.name}",
        user_id: current_user.id
      )
    end
    puts "Mensagens cadastradas com sucesso!"
  end
end