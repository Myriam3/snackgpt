class UserCookingDevice < ApplicationRecord
  belongs_to :profile
  belongs_to :cooking_device

  validates :cooking_device_id, uniqueness: { scope: :profile_id }
end
