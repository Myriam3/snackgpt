class ProfilesController < ApplicationController
  def index
    @profile = current_user.profile

    unless @profile
      redirect_to profile_new_path
      return
    end

    @daily_objective = {
      calories: 2200,
      protein: 150,
      carbs: 250,
      fats: 70
    }

    @diet_suggestion = "Focus on balanced meals with protein, vegetables, and whole-food carbohydrates."
  end

  def new
    redirect_to profile_path if current_user.profile.present?
    @profile = Profile.new
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
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
