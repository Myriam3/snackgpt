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
