class ChatUserPrompt
  def self.call(chat)
    new(chat).call
  end

  def initialize(chat)
    @chat = chat
    @meal = chat.meal
    @profile = @meal.profile
  end

  def call
    <<~PROMPT
      ## User Profile

      Name:
      #{@profile.name}

      Age:
      #{@profile.age}

      Gender:
      #{@profile.gender.humanize}

      Height:
      #{@profile.height} cm

      Weight:
      #{@profile.weight} kg

      Activity Level:
      #{@profile.activity_level.humanize}

      Goal:
      #{@profile.goal.humanize}

      Allergies:
      #{allergies}

      Preferences:
      #{@profile.preferences.presence || 'None'}

      Medical Conditions:
      #{@profile.conditions.presence || 'None'}

      Cooking Devices:
      #{cooking_devices}

      ## Current Meal

      Meal Type:
      #{@meal.meal_type}

      Meal Title:
      #{@meal.meal_title}

      Calories:
      #{@meal.calories} kcal

      Protein:
      #{@meal.protein} g

      Carbohydrates:
      #{@meal.carbs} g

      Fat:
      #{@meal.fats} g

      Recipe:
      #{@meal.content}

      ## Conversation History

      #{conversation_history}

      ## Current Request

      Respond to the user's latest message according to the system instructions.
    PROMPT
  end

  private

  def allergies
    @profile.allergies.pluck(:name).join(", ").presence || "None"
  end

  def cooking_devices
    @profile.cooking_devices.pluck(:name).join(", ").presence || "None"
  end

  def conversation_history
    @chat.messages
         .order(:created_at)
         .map do |message|
           "#{message.role.capitalize}: #{message.content}"
         end
         .join("\n")
  end
end
