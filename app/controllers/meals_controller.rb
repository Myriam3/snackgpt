class MealsController < ApplicationController
  def index
    @profile = current_user.profile

    # Date, meals query
    @date = Date.today
    # TODO: select another day
    @date = '2026-7-23'
    @meals = @profile.meals.where("date = '#{@date}'")

    # Daily objective
    @daily_objective = @profile.daily_objective
    # TODO: calculate with completed meals
    @total_calories = 600
    @total_protein = 50
    @total_carbs = 20
    @total_fats = 50
  end
end
