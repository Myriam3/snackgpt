# This file should ensure the existence of records required to run the application in every environment(production,
  # development, test).The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin / rails db: seed command(or created alongside the database with db: setup).
#
# Example:
  #
#["Action", "Comedy", "Drama", "Horror"].each do | genre_name |
    # MovieGenre.find_or_create_by!(name: genre_name)
  # end
# puts "Cleaning database..."

# User.destroy_all
# Allergy.destroy_all
# CookingDevice.destroy_all

if Allergy.none?
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

  puts "Created allergies"
end

if CookingDevice.none?
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

  puts "Created cooking devices"
end

# User.create(email: "bugsbunnyfitness@example.com", password: "fakiepw123")
# Profile.create(name: "Bugs Bunny", activity_level: 2, gender: 0, birthday: 1999 / 01 / 31, height: 165, weight: 60.5, conditions: "diabetic", goal: 3, "created_at": nil, "updated_at": nil, "user_id": nil, )

email = ENV.fetch("SEED_USER_EMAIL", nil)

unless email
  puts "SEED_USER_EMAIL is missing"
  exit
end

user = User.find_by!(email: email)
profile = user.profile

unless profile
  puts "No existing profile found"
  puts "Done!"
  exit
end

# Add meals to an existing profile
# Generate 3 months of previous meals with Faker
# with random variation for testing the Dashboard
def generate_previous_meals(user_profile)
  puts "deleting previous meals.."

  Meal.where(profile: user_profile)
      .where("date < ?", Date.today)
      .delete_all

  puts "creating previous meals.."

  objective = user_profile.daily_objective

  unless objective
    puts "No daily objective found"
    return
  end

  start_date = 3.months.ago.to_date
  end_date = Date.yesterday

  (start_date..end_date).each do |date|

    # Some days have more or fewer calories
    daily_variation = if rand < 0.15
      rand(1.3..1.7) # high calorie day
    elsif rand < 0.30
      rand(0.7..0.9) # low calorie day
    else
      rand(0.85..1.15) # normal day
    end

    # Meal distribution
    meals = if rand < 0.10
      [
        { type: :brunch, ratio: 0.55 },
        { type: :snack, ratio: 0.10 },
        { type: :dinner, ratio: 0.35 }
      ]
    else
      [
        { type: :breakfast, ratio: 0.20 },
        { type: :lunch, ratio: 0.35 },
        { type: :snack, ratio: 0.10 },
        { type: :dinner, ratio: 0.35 }
      ]
    end

    # Most days complete, some days missing meals
    completed_meals = if rand < 0.90
      meals.map { |meal| meal[:type] }
    else
      meals.sample(rand(1..meals.length))
           .map { |meal| meal[:type] }
    end

    meals.each do |meal|
      meal_variation = rand(0.85..1.15)

      ratio = meal[:ratio]

      Meal.create!(
        profile: user_profile,
        date: date,

        completed: completed_meals.include?(meal[:type]),

        meal_type: meal[:type],

        meal_title: Faker::Food.dish,
        content: "#{Faker::Food.ingredient} with #{Faker::Food.ingredient} and #{Faker::Food.ingredient}",

        calories: (objective.calories * ratio * daily_variation * meal_variation).round,
        protein: (objective.protein * ratio * daily_variation * meal_variation).round,
        carbs: (objective.carbs * ratio * daily_variation * meal_variation).round,
        fats: (objective.fats * ratio * daily_variation * meal_variation).round,

        meal_score: rand(50..100)
      )
    end
  end

  puts "Created #{user_profile.meals.count} meals for #{user_profile.user.email}"
end

generate_previous_meals(profile)
