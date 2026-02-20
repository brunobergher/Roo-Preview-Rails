class Testimonial < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }, allow_blank: true
  validates :city, length: { maximum: 100 }
  validates :message, presence: true, length: { maximum: 500 }

  scope :recent, -> { order(created_at: :desc) }
end
