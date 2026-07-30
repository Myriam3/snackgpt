require 'open-uri'

class FoodDataTool < RubyLLM::Tool
  description "Search USDA FoodData Central for nutrition information."
  param :query,
        desc: "The name of the food to search for."
  API_KEY = ENV.fetch("FOOD_DATA_API_KEY")

  def execute(query:)
    url = "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=#{API_KEY}&query=#{URI.encode_www_form_component(query)}"

    response = JSON.parse(URI.parse(url).read)
    foods = response["foods"].first(3).map do |food|
      {
        description: food["description"],
        nutrients: extract_nutrients(food["foodNutrients"])
      }
    end
    return foods
  rescue StandardError => e # If the API fails, return an error the LLM can explain
    { error: e.message }
  end

  private

  def extract_nutrients(nutrients)
    important = [
      "Energy",
      "Protein",
      "Total lipid (fat)",
      "Carbohydrate, by difference",
      "Fiber, total dietary"
    ]

    nutrients
      .select { |n| important.include?(n["nutrientName"]) }
      .map do |n|
        {
          name: n["nutrientName"],
          amount: n["value"],
          unit: n["unitName"]
        }
      end
  end
end
