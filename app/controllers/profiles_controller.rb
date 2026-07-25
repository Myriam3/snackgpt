# require "nutrition_plan_generator"

class ProfilesController < ApplicationController
  def index
    @profile = current_user.profile

    unless @profile
      redirect_to profile_new_path
      return
    end

    @response = NutritionPlanGenerator.new(@profile).call
    # @daily_objectives = @profile.daily_objectives
    # @meals = @profile.meals
  end

  def new
    redirect_to profile_path if current_user.profile.present?
    @profile = Profile.new
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      # nutrition_plan = NutritionPlanGenerator.new(@profile).call
      # NutritionPlanSaver.new(@profile, nutrition_plan).call
      redirect_to profile_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  private

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
                    { cooking_device_ids: [] }
                  ])
  end
end
