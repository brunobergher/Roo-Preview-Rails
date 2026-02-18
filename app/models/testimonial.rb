class Testimonial < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :name, presence: true
  validates :body, presence: true
end
