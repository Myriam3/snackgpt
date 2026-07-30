class ChatsController < ApplicationController
  def show
    @chat = Chat.find(params[:id])
    render :show
  end
end
