class ChatsController < ApplicationController
  before_action :set_meal
  before_action :set_chat

  def show
    @messages = @chat.messages.order(:created_at)
    @message = Message.new
  end

  def create
    @message = @chat.messages.create!(
      role: :user,
      content: message_params[:content]
    )
    # @message.broadcast_append_to(
    #   @chat,
    #   target: "messages"
    # )

    GenerateChatReplyJob.perform_later(@chat.id)
    redirect_to meal_chat_path(@meal)
  end

  private

  def set_meal
    @meal = current_user.profile.meals.find(params[:id])
  end

  def set_chat
    @chat = @meal.chat || @meal.create_chat(user: current_user)
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
