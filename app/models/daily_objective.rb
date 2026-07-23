class DailyObjective < ApplicationRecord
  belongs_to :profile
  validates :calories, :protein, :carbs, :fats, presence: true
end
