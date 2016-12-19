class WelcomeController < ApplicationController
  def index
    @next_race = Race.where("date > ?", Date.today).first
  end
end
