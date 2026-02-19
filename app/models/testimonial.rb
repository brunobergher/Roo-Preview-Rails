class Testimonial < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 500 }

  scope :recent_first, -> { order(created_at: :desc) }
end
