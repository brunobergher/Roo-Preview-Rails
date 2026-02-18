class Testimonial < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :name, presence: true
  validates :body, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }, allow_blank: true
  validates :bio, length: { maximum: 160, message: "must be 160 characters or fewer" }
end
