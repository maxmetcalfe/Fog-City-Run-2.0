def update_racer_info(racer = nil)
  racer = racer || Racer.find(self.racer_id)
  racer.update_attribute(:race_count, racer.results.count)
  racer.update_attribute(:fav_bib, racer.results.includes(:race).order("races.date DESC").pluck(:bib).first)

  update_streak_calendar(racer)
end

def update_streak_calendar(racer)
  races = racer.results.includes(:race).order("races.date").map {|result| result.race.date }

  streak = []
  current_streak = []
  longest_streak = []
  count_data = []
  count = 0

  current_race = races[0]

  for race in races

    count_data.push([race.to_s, count + 1])
    count = count + 1

    # Check if this race is a consecutive race.
    if (race - current_race).to_i <= 7
      streak.push race
    else
      streak = [race]
    end

    # Check if the streak is the longest streak.
    if streak.length > longest_streak.length
      longest_streak = streak
    end

    # Check if the streak is the current streak.
    diff = (Date.today - streak[-1]).to_i
    if diff >= 0 && diff < 7
      current_streak = streak
    end

    current_race = race
  end

  attributes = {
    :longest_streak => longest_streak.length,
    :current_streak => current_streak.length,
    :longest_streak_array => longest_streak,
    :current_streak_array => current_streak,
    :count_data => count_data
  }
  racer.update_attributes(attributes)
  return attributes
end

def get_next_day_of_week(day_of_week)
  today_wday = Date.today.wday

  if today_wday <= day_of_week
    day = Date.today + (day_of_week - today_wday)
  else
    day = Date.today + (7 - today_wday) + day_of_week
  end

  return day
end
