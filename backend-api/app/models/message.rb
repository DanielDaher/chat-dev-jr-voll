class Message < ApplicationRecord
  belongs_to :user

  def as_json(options={})
    super(
      root: false,
      include: { user: { only: :name }}
    )
  end
end
