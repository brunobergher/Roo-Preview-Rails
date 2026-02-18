class AddBioToTestimonials < ActiveRecord::Migration[8.1]
  def change
    add_column :testimonials, :bio, :string
  end
end
