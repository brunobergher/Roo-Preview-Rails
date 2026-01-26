class Counter < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def self.clicks
    find_or_create_by(name: "clicks") { |c| c.value = 0 }
  end

  def increment!
    with_lock do
      update!(value: value + 1)
    end
  end
end
