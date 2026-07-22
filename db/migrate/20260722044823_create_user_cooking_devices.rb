class CreateUserCookingDevices < ActiveRecord::Migration[8.1]
  def change
    create_table :user_cooking_devices do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :cooking_device, null: false, foreign_key: true

      t.timestamps
    end
  end
end
