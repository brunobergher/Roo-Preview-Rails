class CreateTestimonials < ActiveRecord::Migration[8.1]
  def change
    create_table :testimonials do |t|
      t.string :name, null: false
      t.text :message, null: false
      t.timestamps
    end
  end
end
