# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Cleaning database..."

User.destroy_all
Allergy.destroy_all
CookingDevice.destroy_all

puts "Creating allergies..."

[
  "Peanuts",
  "Tree Nuts",
  "Milk",
  "Eggs",
  "Soy",
  "Wheat",
  "Fish",
  "Shellfish",
  "Sesame"
].each do |name|
  Allergy.create!(name: name)
end

puts "Creating cooking devices..."

[
  "Oven",
  "Microwave",
  "Air Fryer",
  "Rice Cooker",
  "Blender",
  "Pressure Cooker",
  "Slow Cooker",
  "Stovetop"
].each do |name|
  CookingDevice.create!(name: name)
end

puts "Done!"

User.create(email:"bugsbunnyfitness@example.com",password: "fakiepw123" )
Profile.create(name:"Bugs Bunny", activity_level:2, gender:0, birthday:1999/01/31, height: 165, weight:60.5, conditions: "diabetic", goal:3, "created_at": nil, "updated_at": nil, "user_id": nil,)

puts "creating meals.."

Meal.create(
  calories: 560, # cals
  carbs:100, # grams
  protein: 30, # grams
  fats:14, # grams
  completed: false,
  content: "Grilled chicken with cauliflower rice and broccoli",
  date: Date.tomorrow,
  meal_score: 5,
  meal_type: "keto-friendly",
  profile_id: 1,
)
