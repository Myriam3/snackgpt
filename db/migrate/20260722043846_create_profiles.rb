class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.integer :height
      t.integer :weight
      t.date :birthday
      t.integer :gender
      t.integer :activity_level
      t.integer :goal
      t.text :preferences
      t.text :conditions

      t.timestamps
    end
  end
end
