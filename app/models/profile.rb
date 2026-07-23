class Profile < ApplicationRecord
  has_many :user_allergies, dependent: :destroy
  has_many :allergies, through: :user_allergies
  has_many :user_cooking_devices, dependent: :destroy
  has_many :cooking_devices, through: :user_cooking_devices
  validates :name, :birthday, :weight, :height, :gender, :goal, :activity_level, presence: true
  validate :must_have_allergy
  validate :must_have_condition
  validate :must_have_preference
  validate :must_have_cooking_device

  private

  def must_have_allergy
    errors.add(:allergies, "Must select at least one") if allergies.empty?
  end

  def must_have_cooking_device
    errors.add(:cooking_devices, "Must select at least one") if cooking_devices.empty?
  end
end
