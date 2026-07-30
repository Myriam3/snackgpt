class ProfilesController < ApplicationController
  def index
    @profile = current_user.profile || (redirect_to(profile_new_path) && return)
  end

  def new
    redirect_to profile_path if current_user.profile.present?
    @profile = Profile.new
  end

  def create
    @profile = current_user.build_profile(profile_params)
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
    if @profile.update(profile_params)
      Turbo::StreamsChannel.broadcast_replace_to(
        @profile,
        target: "nutrition_plan",
        partial: "profiles/nutrition_loading"
      )
      GenerateNutritionPlanJob.perform_later(@profile.id)
      redirect_to profile_path,
                  notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
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
