class AddCityToTestimonials < ActiveRecord::Migration[8.1]
  def change
    add_column :testimonials, :city, :string
  end
end
