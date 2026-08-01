class GenerateChatReplyJob < ApplicationJob
  queue_as :default

  def perform(chat_id)
    chat = Chat.find(chat_id)

    result = ChatReplyGenerator.new(chat).call
    chat.messages.create!(
      role: :assistant,
      content: result["reply"]
    )
    assistant_message.broadcast_append_to(
      chat,
      target: "messages"
    )
    return unless result["updated_meal"].present?
    chat.meal.update!(
      meal_title: result["updated_meal"]["meal_title"],
      content: result["updated_meal"]["content"],
      calories: result["updated_meal"]["calories"],
      protein: result["updated_meal"]["protein"],
      carbs: result["updated_meal"]["carbs"],
      fats: result["updated_meal"]["fats"]
    )
    end
  end
end
