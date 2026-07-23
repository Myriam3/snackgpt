class CreateCookingDevices < ActiveRecord::Migration[8.1]
  def change
    create_table :cooking_devices do |t|
      t.string :name

      t.timestamps
    end
  end
end
