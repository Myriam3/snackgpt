class MessagesController < ApplicationController
  def create
    user_message = params[:message][:content]

    # Save user message to database (example model setup)
    @chat.messages.create(role: "user", content: user_message)

    # Initialize OpenAI client
    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:openai, :api_key))

    # Request chat completion from OpenAI API
    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: user_message }]
      }
    )

    # Extract assistant reply content
    ai_reply = response.dig("choices", 0, "message", "content")

    # Save assistant message to database
    @chat.messages.create(role: "assistant", content: ai_reply)

    respond_to do |format|
      format.html { redirect_to @chat }
      format.turbo_stream
    end
  end
end
