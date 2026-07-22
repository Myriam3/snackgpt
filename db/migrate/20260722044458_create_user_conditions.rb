class CreateUserConditions < ActiveRecord::Migration[8.1]
  def change
    create_table :user_conditions do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :condition, null: false, foreign_key: true

      t.timestamps
    end
  end
end
