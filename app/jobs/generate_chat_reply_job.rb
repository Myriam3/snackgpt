class GenerateChatReplyJob < ApplicationJob
  include ActionView::RecordIdentifier

  queue_as :default

  def perform(chat_id)
    chat = Chat.find(chat_id)

    assistant_message = chat.messages.create!(
      role: :assistant,
      content: ""
    )
    broadcast_message(assistant_message)
    stream_response(chat, assistant_message)
  end

  private

  def stream_response(chat, assistant_message)
    full_response = ""

    RubyLLM
      .chat
      .with_instructions(ChatSystemPrompt::SYSTEM_PROMPT)
      .ask(ChatUserPrompt.call(chat)) do |chunk|
        text = chunk.content.to_s
        next if text.empty?

        full_response += text
        clean_response = remove_meal_update(full_response)

        assistant_message.update!(
          content: clean_response
        )

        broadcast_message(assistant_message)
      end

    process_meal_update(chat, full_response)
  end

  def process_meal_update(chat, response)
    meal_update = response.match(
      %r{<MEAL_UPDATE>(.*?)</MEAL_UPDATE>}m
    )

    return unless meal_update

    meal_data = JSON.parse(meal_update[1])

    chat.meal.update!(
      meal_title: meal_data["meal_title"],
      content: meal_data["content"],
      calories: meal_data["calories"],
      protein: meal_data["protein"],
      carbs: meal_data["carbs"],
      fats: meal_data["fats"]
    )
  rescue JSON::ParserError => e
    Rails.logger.error "AI response was not valid JSON: #{response}"
    Rails.logger.error e.message
  end

  def broadcast_message(message)
    Turbo::StreamsChannel.broadcast_replace_to(
      message.chat,
      target: dom_id(message),
      partial: "messages/message",
      locals: { message: message }
    )
  end

  # def remove_meal_update(response)
  #   response
  #     .gsub(%r{<MEAL_UPDATE>.*?</MEAL_UPDATE>}m, "")
  #     .strip
  # end
  def remove_meal_update(response)
    response
      .gsub(/<MEAL_UPDATE>.*/m, "")
      .strip
  end
end
