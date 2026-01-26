class CreateCounters < ActiveRecord::Migration[8.0]
  def change
    create_table :counters do |t|
      t.string :name, null: false
      t.integer :value, default: 0, null: false
      t.timestamps
    end

    add_index :counters, :name, unique: true
  end
end
