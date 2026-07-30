class ChatsController < ApplicationController
  def show
    @chat = Chat.find(params[:id].to_i)
    @message = Message.new
    render :show
  end
end
