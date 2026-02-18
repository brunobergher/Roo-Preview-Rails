class Testimonial < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :name, presence: true
  validates :body, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }, allow_blank: true
end
