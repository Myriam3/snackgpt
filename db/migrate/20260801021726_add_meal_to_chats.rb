class AddMealToChats < ActiveRecord::Migration[8.1]
  def change
    add_reference :chats, :meal, null: false, foreign_key: true
  end
end
