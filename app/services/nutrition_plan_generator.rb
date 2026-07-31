require "json"

class NutritionPlanGenerator
  def initialize(profile)
    @profile = profile
  end

  def call
    Rails.logger.info "OPENAI key present? #{ENV['OPENAI_API_KEY'].present?}"
    @response = RubyLLM.chat.with_instructions(NutritionSystemPrompt::SYSTEM_PROMPT).with_tool(FoodDataTool).ask(user_prompt)
    JSON.parse(@response.content)
  end

  private

  attr_reader :profile

  def user_prompt
    NutritionUserPrompt.call(profile)
  end
end
