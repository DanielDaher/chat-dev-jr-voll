class AddSendToToMessages < ActiveRecord::Migration[8.0]
  def change
    add_reference :messages, :send_to, null: false, foreign_key: { to_table: :users }
  end
end
