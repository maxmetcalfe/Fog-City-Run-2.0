require "#{Rails.root}/lib/utils"

class NextRaceController < ApplicationController
  def show
    race_date = get_next_day_of_week(3)
    race = Race.find_by(date: race_date)

    if race
      render json: { status: "exists", date: race_date }, status: :ok
    else
      race = Race.create!(date: race_date, state: "PLANNED")
      render json: { status: "created", date: race.date }, status: :created
    end
  end
end
