require_relative "../utils"

# Auto-create a future Wednesday race.
task :create_next_race => :environment do
  race_date = get_next_day_of_week(3)
  if !Race.exists?(date: race_date)
    race = Race.new(date: race_date, state: "PLANNED")
    race.save!
    puts "Race auto-create - race created: " + race_date.to_s
  else
    puts "Race auto-create - race already exists: " + race_date.to_s
  end
end
