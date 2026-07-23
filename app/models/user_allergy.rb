class UserAllergy < ApplicationRecord
  belongs_to :profile
  belongs_to :allergy

  validates :allergy_id, uniqueness: { scope: :profile_id }
end
