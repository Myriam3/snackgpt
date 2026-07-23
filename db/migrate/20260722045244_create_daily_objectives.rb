class CreateDailyObjectives < ActiveRecord::Migration[8.1]
  def change
    create_table :daily_objectives do |t|
      t.references :profile, null: false, foreign_key: true
      t.integer :calories
      t.integer :protein
      t.integer :carbs
      t.integer :fats

      t.timestamps
    end
  end
end
