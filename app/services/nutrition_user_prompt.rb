class NutritionUserPrompt
  def self.call(profile)
    <<~PROMPT
      User Profile

      Name: #{profile.name}
      Age: #{profile.age}
      Gender: #{profile.gender.humanize}
      Height: #{profile.height} cm
      Weight: #{profile.weight} kg

      Activity Level:
      #{profile.activity_level.humanize}

      Goal:
      #{profile.goal.humanize}

      Preferences:
      #{profile.preferences.presence || 'None'}

      Medical Conditions:
      #{profile.conditions.presence || 'None'}

      Allergies:
      #{profile.allergies.pluck(:name).join(', ').presence || 'None'}

      Cooking Devices:
      #{profile.cooking_devices.pluck(:name).join(', ').presence || 'Unknown'}
    PROMPT
  end
end
