class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  belongs_to :meal, optional: true
end
