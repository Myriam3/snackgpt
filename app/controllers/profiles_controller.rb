class ProfilesController < ApplicationController
  def index
    @profile = current_user.profile || (redirect_to(profile_new_path) && return)
  end

  def new
    redirect_to profile_path if current_user.profile.present?
    @profile = Profile.new
  end

  def create
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

    @profile = current_user.build_profile(attributes)

    if @profile.save
      GenerateNutritionPlanJob.perform_later(@profile.id)
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

  def find_or_create_allergies(names)
    ids = []

    Array(names).each do |name|
      name = name.to_s.strip
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
      name = name.to_s.strip
      next if name.blank?

      cooking_device = CookingDevice.where("LOWER(name) = ?", name.downcase).first
      cooking_device ||= CookingDevice.create!(name: name)

      ids << cooking_device.id.to_s unless ids.include?(cooking_device.id.to_s)
    end

    ids
  end

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
end
