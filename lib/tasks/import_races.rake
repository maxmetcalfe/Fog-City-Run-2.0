task :import_races => :environment do
require 'csv'   
CSV.foreach("/Users/max/Documents/Home/Fog-City-Run-2.0/input_data/input_dates_final.csv", :headers => true) do |row|
	puts row
    Race.create(:date => row['date'])
end
end