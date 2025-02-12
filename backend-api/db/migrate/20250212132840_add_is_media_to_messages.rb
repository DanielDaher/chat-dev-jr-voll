class AddIsMediaToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :is_media, :boolean, default: nil
  end
end
