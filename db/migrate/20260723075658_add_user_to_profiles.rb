class AddUserToProfiles < ActiveRecord::Migration[8.1]
  def change
    add_reference :profiles, :user, null: false, foreign_key: true
  end
end
