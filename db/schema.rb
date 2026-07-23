# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_23_075658) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "allergies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "bookmarks", force: :cascade do |t|
    t.string "comment"
    t.datetime "created_at", null: false
    t.bigint "list_id", null: false
    t.bigint "movie_id", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_bookmarks_on_list_id"
    t.index ["movie_id"], name: "index_bookmarks_on_movie_id"
  end

  create_table "chats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "cooking_devices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "daily_objectives", force: :cascade do |t|
    t.integer "calories"
    t.integer "carbs"
    t.datetime "created_at", null: false
    t.integer "fats"
    t.bigint "profile_id", null: false
    t.integer "protein"
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_daily_objectives_on_profile_id"
  end

  create_table "lists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "meals", force: :cascade do |t|
    t.integer "calories"
    t.integer "carbs"
    t.boolean "completed"
    t.text "content"
    t.datetime "created_at", null: false
    t.date "date"
    t.integer "fats"
    t.string "meal_image_url"
    t.integer "meal_score"
    t.integer "meal_type"
    t.bigint "profile_id", null: false
    t.integer "protein"
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_meals_on_profile_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "movies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "overview"
    t.string "poster_url"
    t.float "rating"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "activity_level"
    t.date "birthday"
    t.text "conditions"
    t.datetime "created_at", null: false
    t.integer "gender"
    t.integer "goal"
    t.integer "height"
    t.string "name"
    t.text "preferences"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "weight"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "user_allergies", force: :cascade do |t|
    t.bigint "allergy_id", null: false
    t.datetime "created_at", null: false
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["allergy_id"], name: "index_user_allergies_on_allergy_id"
    t.index ["profile_id"], name: "index_user_allergies_on_profile_id"
  end

  create_table "user_cooking_devices", force: :cascade do |t|
    t.bigint "cooking_device_id", null: false
    t.datetime "created_at", null: false
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["cooking_device_id"], name: "index_user_cooking_devices_on_cooking_device_id"
    t.index ["profile_id"], name: "index_user_cooking_devices_on_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookmarks", "lists"
  add_foreign_key "bookmarks", "movies"
  add_foreign_key "chats", "users"
  add_foreign_key "daily_objectives", "profiles"
  add_foreign_key "meals", "profiles"
  add_foreign_key "messages", "chats"
  add_foreign_key "profiles", "users"
  add_foreign_key "user_allergies", "allergies"
  add_foreign_key "user_allergies", "profiles"
  add_foreign_key "user_cooking_devices", "cooking_devices"
  add_foreign_key "user_cooking_devices", "profiles"
end
