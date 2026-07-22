class UserCondition < ApplicationRecord
  belongs_to :profile
  belongs_to :condition

  validates :condition_id, uniqueness: { scope: :profile_id }
end
