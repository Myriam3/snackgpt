class CreatePreferences < ActiveRecord::Migration[8.1]
  def change
    create_table :preferences do |t|
      t.string :name

      t.timestamps
    end
  end
end
