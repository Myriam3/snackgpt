class AddNutritionSummaryToDailyObjectives < ActiveRecord::Migration[8.1]
  def change
    add_column :daily_objectives, :nutrition_summary, :text
  end
end
