class AddMealTitleToMeals < ActiveRecord::Migration[8.1]
  def change
    add_column :meals, :meal_title, :string
  end
end
