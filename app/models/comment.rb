class Comment < ApplicationRecord
  belongs_to :testimonial

  validates :author_name, presence: true
  validates :body, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }, allow_blank: true
end
