class AddPasswordToUserAndMakeNameUnique < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :password_digest, :string
    add_index :users, :name, unique: true
  end
end
