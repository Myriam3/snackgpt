class ChatReplyGenerator
  def initialize(chat)
    @chat = chat
  end

  def call
    response = RubyLLM
               .chat
               .with_instructions(ChatSystemPrompt::SYSTEM_PROMPT)
               .with_tool(FoodDataTool)
               .ask(ChatUserPrompt.call(@chat))

    JSON.parse(response.content)
  rescue JSON::ParserError => e
    Rails.logger.error("Invalid AI JSON response: #{response.content}")
    raise e
  end
end
