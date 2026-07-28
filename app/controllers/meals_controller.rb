class MealsController < ApplicationController
  before_action :set_profile, only: %i[index create complete]
  before_action :set_daily_objective, only: %i[index complete]

  # Daily meals, objectives & progress
  def index
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @meals = daily_meals(@date).order(meal_type: :asc)
    @daily_progress = daily_progress(@meals, @daily_objective)
  end

  # Show one meal
  def show
    @meal = Meal.find(params[:id])
  end

  # Create a new meal
  def create
    @meal = @profile.meals.build(meal_params)

    if @meal.save
      redirect_to meals_path(date: @meal.date)
    else
      render :meals, status: :unprocessable_entity
    end
  end

  # Complete a meal
  def complete
    @meal = Meal.find(params[:id])

    if @meal.update(completed: params[:meal][:completed])
      @daily_progress = daily_progress(daily_meals(@meal.date), @daily_objective)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to meals_path(date: @meal.date) }
      end
    else
      head :unprocessable_entity
    end
  end

  private

  # Set user profile
  def set_profile
    @profile = current_user.profile
  end

  # Set daily objective
  def set_daily_objective
    @daily_objective = @profile.daily_objective
  end

  # Meal params
  def meal_params
    params.require(:meal).permit(
      :content,
      :calories,
      :protein,
      :carbs,
      :fats,
      :date,
      :meal_type
    )
  end

  # Get daily meals
  def daily_meals(date)
    @profile.meals.where(date: date)
  end

  # Calculate daily progress
  def daily_progress(meals, daily_objective)
    completed_meals = meals.where(completed: true)

    {
      calories: progress(completed_meals.sum(:calories), daily_objective.calories),
      protein: progress(completed_meals.sum(:protein), daily_objective.protein),
      carbs: progress(completed_meals.sum(:carbs), daily_objective.carbs),
      fats: progress(completed_meals.sum(:fats), daily_objective.fats)
    }
  end

  def progress(total, objective)
    {
      total: total,
      percent: percent(total, objective)
    }
  end

  def percent(total, objective)
    return 0 if objective.zero?

    total * 100 / objective
  end
end
