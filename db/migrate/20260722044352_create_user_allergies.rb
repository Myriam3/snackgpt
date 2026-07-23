class CreateUserAllergies < ActiveRecord::Migration[8.1]
  def change
    create_table :user_allergies do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :allergy, null: false, foreign_key: true

      t.timestamps
    end
  end
end
