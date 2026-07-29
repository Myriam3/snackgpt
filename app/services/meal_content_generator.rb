class MealContentGenerator
  def initialize(meal)
    @meal = meal
  end

  def call
    response = RubyLLM.chat.with_instructions(MealContentPrompt::SYSTEM_PROMPT).ask(user_prompt)
    JSON.parse(response.content)
  end

  private

  def user_prompt
    <<~PROMPT
      Generate recipe details for this meal:

      Meal title:
      #{@meal.meal_title}

      Meal type:
      #{@meal.meal_type}

      Nutrition target:
      Calories: #{@meal.calories} kcal
      Protein: #{@meal.protein} g
      Carbs: #{@meal.carbs} g
      Fat: #{@meal.fats} g

      User requirements:

      Allergies:
      #{@meal.profile.allergies.pluck(:name).join(', ')}

      Cooking devices:
      #{@meal.profile.cooking_devices.pluck(:name).join(', ')}

      Preferences:
      #{@meal.profile.preferences}

      Conditions:
      #{@meal.profile.conditions}
    PROMPT
  end
end
