class Meal < ApplicationRecord
  belongs_to :profile
  validates :meal_type, :date, :calories, :protein, :carbs, :fats, :content, presence: true
end
