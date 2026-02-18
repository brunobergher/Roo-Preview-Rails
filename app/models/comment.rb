class Comment < ApplicationRecord
  belongs_to :testimonial

  validates :author_name, presence: true
  validates :body, presence: true
end
