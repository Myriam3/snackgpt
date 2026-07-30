class GenerateMealContentJob < ApplicationJob
  queue_as :default

  def perform(meal_id)
    meal = Meal.find(meal_id)
    result = MealContentGenerator.new(meal).call
    meal.update!(
      content: result["content"]
    )
  end
end
