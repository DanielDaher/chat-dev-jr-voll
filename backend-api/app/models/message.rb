class Message < ApplicationRecord
  belongs_to :user
  belongs_to :send_to, class_name: "User", foreign_key: "send_to_id"

  def as_json(options={})
    super(
      root: false,
      include: { user: { only: [:id, :name] }, send_to: { only: [:id, :name] } }
    )
  end
end
