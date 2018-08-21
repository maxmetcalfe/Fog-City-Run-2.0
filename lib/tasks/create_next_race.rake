require_relative "../utils"

task :create_next_race => :environment do
  race_date = get_next_day_of_week(6)
  race = Race.new(date: race_date)
  race.save!
  puts "New race created: " + race.date.to_s
end
