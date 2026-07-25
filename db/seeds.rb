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
UserCookingDevice.destroy_all
UserAllergy.destroy_all

Profile.destroy_all
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


puts "seeding users"

User.find_or_create_by!(email: "cammyfitness@example.com") do |user|
  user.password = "SecurePassword123"
  user.password_confirmation = "SecurePassword123"

  user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
end

puts "Seeding completed successfully!"

Profile.create!(
  user: user,
  gender: 2
  birthday: Date.new(1995, 5, 14)
  activity_level 2,
  diet_goals: "Muscle gain",
  height: 175.5, # in centimeters
  weight: 68.0   # in kilograms
  allergies: "Shellfish"
)

puts "Successfully seeded 1 user and profile!"
