def update_racer_info(racer = nil)
  racer = racer || Racer.find(self.racer_id)
  racer.update_attribute(:race_count, racer.results.count)
  racer.update_attribute(:fav_bib, racer.results.includes(:race).order("races.date DESC").pluck(:bib).first)

  update_streak_calendar(racer)
end

def update_streak_calendar(racer)
  open_dates = []
  open_dates = open_dates.push '2013-01-16'.to_date
  while open_dates[-1] <= Date.today - 1.week
    open_dates = open_dates.push open_dates[-1].advance(:weeks => 1)
  end
  races_run = racer.results.joins(:race).map {|result| Race.find(result.race_id).date }
  longest_streak_count = 0
  longest_streak = []
  current_streak_count = 0
  current_streak = []
  for o in open_dates
    found = 0
    for r in races_run
      if o == r
        current_streak = current_streak.push r
        if current_streak.length > longest_streak_count
          longest_streak_count = current_streak.length
          longest_streak = current_streak
        end
        found = 1
        if open_dates[-1] == current_streak[-1]
          current_streak_count = current_streak.length
        end
      end
    end
    if found == 0
      current_streak = []
    end
  end
  attributes = {
    :longest_streak => longest_streak.length,
    :current_streak => current_streak.length,
    :longest_streak_array => longest_streak,
    :current_streak_array => current_streak
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
