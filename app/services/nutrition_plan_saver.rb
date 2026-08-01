class NutritionPlanSaver
  def initialize(profile, nutrition_plan)
    @profile = profile
    @nutrition_plan = nutrition_plan
  end

  def call
    save_daily_objective
    save_meals
  end

  private

  attr_reader :profile, :nutrition_plan

  def save_daily_objective
    profile.create_daily_objective!(
      calories: nutrition_plan["daily_objectives"]["calories"],
      protein: nutrition_plan["daily_objectives"]["protein_g"],
      carbs: nutrition_plan["daily_objectives"]["carbs_g"],
      fats: nutrition_plan["daily_objectives"]["fat_g"],
      nutrition_summary: nutrition_plan["nutrition_summary"]
    )
  end

  def save_meals
    nutrition_plan["weekly_meal_plan"].each do |meal|
      profile.meals.create!(
        date: meal["date"],
        meal_type: meal["meal_type"],
        meal_title: meal["meal_title"],
        content: "Recipe will be generated soon.",
        calories: meal["calories"],
        protein: meal["protein"],
        carbs: meal["carbs"],
        fats: meal["fats"],
        completed: false
      )
    end
  end
end
