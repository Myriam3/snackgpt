class Profile < ApplicationRecord
  has_many :user_allergies, dependent: :destroy
  has_many :allergies, through: :user_allergies
  has_many :user_cooking_devices, dependent: :destroy
  has_many :cooking_devices, through: :user_cooking_devices
  validates :name, :birthday, :weight, :height, :gender, :goal, :activity_level, presence: true
  validate :must_have_cooking_device
  belongs_to :user

  enum :gender, {
    male: 0,
    female: 1,
    non_binary: 2,
    prefer_not_to_say: 3
  }

  enum :goal, {
    lose_weight: 0,
    maintain_weight: 1,
    gain_weight: 2,
    build_muscle: 3,
    eat_healthier: 4
  }

  enum :activity_level, {
    sedentary: 0,
    lightly_active: 1,
    moderately_active: 2,
    very_active: 3,
    athlete: 4
  }

  private

  def must_have_cooking_device
    errors.add(:cooking_devices, "Must select at least one") if cooking_devices.empty?
  end
end
