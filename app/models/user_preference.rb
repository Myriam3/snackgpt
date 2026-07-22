class UserPreference < ApplicationRecord
  belongs_to :profile
  belongs_to :preference

  validates :preference_id, uniqueness: { scope: :profile_id }
end
