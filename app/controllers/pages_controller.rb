class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    return unless current_user&.profile

    redirect_to(profile_path)
  end
end
