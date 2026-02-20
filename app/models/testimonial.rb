class Testimonial < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }
  validates :message, presence: true, length: { maximum: 500 }

  scope :recent, -> { order(created_at: :desc) }
end
