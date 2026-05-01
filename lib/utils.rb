def update_racer_info(racer = nil)
  racer = racer || Racer.find(self.racer_id)
  racer.update_attribute(:race_count, racer.results.count)
  racer.update_attribute(:fav_bib, racer.results.includes(:race).order("races.date DESC").pluck(:bib).first)
  update_streak_calendar(racer)
end

def update_streak_calendar(racer)
  races = racer.results.includes(:race).order("races.date").map {|result| result.race&.date }.compact
  return if races.empty?

  streak = []
  current_streak = []
  longest_streak = []
  count_data = []
  count = 0
  current_race = races[0]

  races.each do |race|
    count_data.push([race.to_s, count + 1])
    count += 1

    if (race - current_race).to_i <= 7
      streak.push(race)
    else
      streak = [race]
    end

    longest_streak = streak if streak.length > longest_streak.length

    last_date = streak[-1]
    if last_date
      begin
        parsed_date = last_date.to_date
        diff = (Date.today - parsed_date).to_i
        current_streak = streak if diff >= 0 && diff < 7
      rescue => e
        puts "DEBUG: Failed to parse date: #{last_date.inspect} (#{e.message})"
      end
    end

    current_race = race
  end

  attributes = {
    longest_streak: longest_streak.length,
    current_streak: current_streak.length,
    longest_streak_array: longest_streak,
    current_streak_array: current_streak,
    count_data: count_data
  }
  racer.update(attributes)
  attributes
end

def get_next_day_of_week(day_of_week)
  today_wday = Date.today.wday
  if today_wday <= day_of_week
    Date.today + (day_of_week - today_wday)
  else
    Date.today + (7 - today_wday) + day_of_week
  end
end
