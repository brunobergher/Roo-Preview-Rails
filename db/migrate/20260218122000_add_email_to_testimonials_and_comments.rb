class AddEmailToTestimonialsAndComments < ActiveRecord::Migration[8.1]
  def change
    add_column :testimonials, :email, :string
    add_column :comments, :email, :string
  end
end
