class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  
  def interacted_with_users
    User.find_by_sql([
      "SELECT DISTINCT u.* FROM users u
       INNER JOIN messages m ON u.id = m.send_to_id WHERE m.user_id = ?
       UNION
       SELECT DISTINCT u.* FROM users u
       INNER JOIN messages m ON u.id = m.user_id WHERE m.send_to_id = ?",
      id, id
    ])
  end
end
