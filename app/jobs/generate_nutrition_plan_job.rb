class GenerateNutritionPlanJob < ApplicationJob
  queue_as :default

  def perform(profile_id)
    profile = Profile.find(profile_id)

    nutrition_plan = NutritionPlanGenerator.new(profile).call
    NutritionPlanSaver.new(profile, @nutrition_plan).call

    Turbo::StreamsChannel.broadcast_replace_to(
      profile,
      target: "nutrition_plan",
      partial: "profiles/nutrition_plan",
      locals: {
        daily_objective: profile.daily_objective,
        meals: profile.meals
      }
    )
  end
end
