class AddEmailToTestimonials < ActiveRecord::Migration[8.1]
  def change
    add_column :testimonials, :email, :string
  end
end
