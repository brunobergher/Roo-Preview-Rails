class AddCountryToTestimonials < ActiveRecord::Migration[8.1]
  def change
    add_column :testimonials, :country, :string
  end
end
