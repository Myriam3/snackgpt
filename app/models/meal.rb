class Meal < ApplicationRecord
  belongs_to :profile
  validates :meal_type, :date, :calories, :protein, :carbs, :fats, :content, presence: true

  enum :meal_type, {
    breakfast: 0,
    lunch: 1,
    brunch: 2,
    snack: 3,
    dinner: 4
  }
end
