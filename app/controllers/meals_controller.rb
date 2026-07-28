class MealsController < ApplicationController
  def index
    @profile = current_user.profile

    # Date
    @date = Date.today
    # TODO: select another day
    @date = Date.new(2026, 7, 23)

    # Meals
    @meals = daily_meals(@date)

    # Daily objective / progress
    @daily_objective = @profile.daily_objective
    @daily_progress = daily_progress(@meals, @daily_objective)
  end

  def show
    @meal = Meal.find(params[:id])
  end

  def complete
    @profile = current_user.profile
    @daily_objective = current_user.profile.daily_objective
    @meal = Meal.find(params[:id])

    if @meal.update(completed: params[:meal][:completed])
      @daily_objective = @profile.daily_objective
      meals = daily_meals(@meal.date)
      @daily_progress = daily_progress(meals, @daily_objective)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to meals_path }
      end
    else
      head :unprocessable_entity
    end
  end

  private

  def daily_meals(date)
    @profile.meals.where("date = '#{date}'")
  end

  def daily_progress(meals, daily_objective)
    completed_meals = meals.where(completed: true)
    calories = completed_meals.sum(:calories)
    protein = completed_meals.sum(:protein)
    carbs = completed_meals.sum(:carbs)
    fats = completed_meals.sum(:fats)

    {
      calories: {
        total: calories,
        percent: percent(calories, daily_objective.calories)
      },
      protein: {
        total: protein,
        percent: percent(protein, daily_objective.protein)
      },
      carbs: {
        total: carbs,
        percent: percent(carbs, daily_objective.carbs)
      },
      fats: {
        total: fats,
        percent: percent(fats, daily_objective.fats)
      }
    }
  end

  def percent(total, objective)
    return 0 if objective.zero?

    total * 100 / objective
  end
end
