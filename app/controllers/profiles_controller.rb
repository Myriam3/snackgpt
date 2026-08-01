class ProfilesController < ApplicationController
  def index
    @profile = current_user.profile || (redirect_to(profile_new_path) && return)

    @range = params[:range] || "week"
    @end_date = Date.today
    @start_date = 6.days.ago.to_date
    if @range == "month"
      @start_date = 1.month.ago.to_date
    elsif @range == "three_months"
      @start_date = 3.months.ago.to_date
    end

    generate_stats(@start_date, @end_date)
  end

  def new
    redirect_to profile_path if current_user.profile.present?
    @profile = Profile.new
  end

  def create
    @profile = current_user.build_profile(processed_profile_attributes)

    if @profile.save
      GenerateNutritionPlanJob.perform_later(@profile.id)
      redirect_to profile_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @profile = current_user.profile || (redirect_to(profile_new_path) && return)
  end

  def update
    @profile = current_user.profile

    if @profile.update(processed_profile_attributes)
      @profile.daily_objective&.destroy
      @profile.meals.destroy_all
      GenerateNutritionPlanJob.perform_later(@profile.id)
      redirect_to profile_path,
                  notice: "Profile updated successfully."
      # Turbo::StreamsChannel.broadcast_replace_to(
      #   @profile,
      #   target: "nutrition_plan",
      #   partial: "profiles/nutrition_loading"
      # )
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def find_or_create_allergies(names)
    ids = []

    Array(names).each do |name|
      name = name.to_s.strip.titleize
      next if name.blank?

      allergy = Allergy.where("LOWER(name) = ?", name.downcase).first
      allergy ||= Allergy.create!(name: name)

      ids << allergy.id.to_s unless ids.include?(allergy.id.to_s)
    end

    ids
  end

  def find_or_create_cooking_devices(names)
    ids = []

    Array(names).each do |name|
      name = name.to_s.strip.titleize
      next if name.blank?

      cooking_device = CookingDevice.where("LOWER(name) = ?", name.downcase).first
      cooking_device ||= CookingDevice.create!(name: name)

      ids << cooking_device.id.to_s unless ids.include?(cooking_device.id.to_s)
    end

    ids
  end

  # Params
  def profile_params
    params.expect(profile: [
                    :name,
                    :height,
                    :weight,
                    :birthday,
                    :gender,
                    :activity_level,
                    :goal,
                    :preferences,
                    :conditions,
                    { allergy_ids: [] },
                    { cooking_device_ids: [] },
                    { custom_allergies: [] },
                    { custom_cooking_devices: [] }
                  ])
  end

  # Dashboard stats
  def generate_stats(start_date, end_date)
    @summary = summary_between(start_date, end_date)
    @calorie_stats = calorie_stats(start_date, end_date)
    @calorie_accuracy = calorie_accuracy_stats(start_date, end_date)
    @macro_progress = macro_progress(start_date, end_date)
    @macro_distribution = macro_distribution(start_date, end_date)
  end

  def meals_between(start_date, end_date)
    @profile.meals.where(date: start_date..end_date)
  end

  # Summary
  def summary_between(start_date, end_date)
    meals = meals_between(start_date, end_date)
    completed_meals = meals.where(completed: true)

    days = (end_date - start_date).to_i + 1

    {
      calories: completed_meals.sum(:calories) / days,
      protein: completed_meals.sum(:protein) / days,
      carbs: completed_meals.sum(:carbs) / days,
      fats: completed_meals.sum(:fats) / days,
      completion: meals.none? ? 0 : (completed_meals.count * 100 / meals.count),
      meal_number: completed_meals.length
    }
  end

  # Calorie chart
  def calorie_stats(start_date, end_date)
    (start_date..end_date).map do |date|
      meals = meals_between(date, date)
      completed_meals = meals.where(completed: true)

      {
        date: date,
        calories: completed_meals.sum(:calories),
        objective: @profile.daily_objective.calories
      }
    end
  end

  # Calorie objectives
  def calorie_accuracy_stats(start_date, end_date)
    stats = calorie_stats(start_date, end_date)

    return {} if stats.empty?

    objective = @profile.daily_objective.calories
    margin = 0.10

    min = objective * (1 - margin)
    max = objective * (1 + margin)

    total_days = stats.count

    {
      on_target: stats.count { |day| day[:calories].between?(min, max) } * 100 / total_days,
      below: stats.count { |day| day[:calories] < min } * 100 / total_days,
      above: stats.count { |day| day[:calories] > max } * 100 / total_days
    }
  end

  def macro_progress(start_date, end_date)
    summary = summary_between(start_date, end_date)
    objective = @profile.daily_objective

    {
      protein: {
        consumed: summary[:protein],
        goal: objective.protein,
        percent: summary[:protein] * 100 / objective.protein
      },
      carbs: {
        consumed: summary[:carbs],
        goal: objective.carbs,
        percent: summary[:carbs] * 100 / objective.carbs
      },
      fats: {
        consumed: summary[:fats],
        goal: objective.fats,
        percent: summary[:fats] * 100 / objective.fats
      }
    }
  end

  def macro_distribution(start_date, end_date)
    summary = summary_between(start_date, end_date)

    protein_calories = summary[:protein] * 4
    carbs_calories = summary[:carbs] * 4
    fats_calories = summary[:fats] * 9

    {
      Protein: protein_calories,
      Carbs: carbs_calories,
      Fats: fats_calories
    }
  end

  def processed_profile_attributes
    attributes = profile_params

    custom_allergies = attributes.delete(:custom_allergies)
    custom_cooking_devices = attributes.delete(:custom_cooking_devices)

    selected_allergy_ids = Array(attributes[:allergy_ids]).map(&:to_s)
    selected_cooking_device_ids = Array(attributes[:cooking_device_ids]).map(&:to_s)

    custom_allergy_ids = find_or_create_allergies(custom_allergies)
    custom_cooking_device_ids = find_or_create_cooking_devices(custom_cooking_devices)

    attributes[:allergy_ids] =
      (selected_allergy_ids + custom_allergy_ids).uniq

    attributes[:cooking_device_ids] =
      (selected_cooking_device_ids + custom_cooking_device_ids).uniq

    attributes
  end
end
