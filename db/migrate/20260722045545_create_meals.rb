class CreateMeals < ActiveRecord::Migration[8.1]
  def change
    create_table :meals do |t|
      t.references :profile, null: false, foreign_key: true
      t.integer :meal_type
      t.date :date
      t.integer :calories
      t.integer :protein
      t.integer :carbs
      t.integer :fats
      t.text :content
      t.boolean :completed
      t.string :meal_image_url
      t.integer :meal_score

      t.timestamps
    end
  end
end
