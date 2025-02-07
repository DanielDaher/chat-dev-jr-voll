namespace :dev do
  desc "TODO"
  task setup: :environment do
    puts "Cadastrando usuários..."
    10.times do |i|
      User.create!(
        name: Faker::Name.name,
      )
    end
    puts "Usuários cadastrados com sucesso!"
  end

end
