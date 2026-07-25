class Message < ApplicationRecord
  belongs_to :chat, dependent: :destroy

  enum :role, {
    user: "user",
    assistant: "assistant"
  }
end
