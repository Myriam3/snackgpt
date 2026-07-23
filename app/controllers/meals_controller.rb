class MealsController < ApplicationController
  def index
    @profile = current_user.profile

    @date = Date.today
    # TODO: select another day
    @date = '2026-7-23'
    @meals = @profile.meals.where("date = '#{@date}'")
  end
end
