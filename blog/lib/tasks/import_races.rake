task :import_races => :environment do
require 'csv'   
CSV.foreach("/Users/max/Documents/Home/learningRubyonRails/input_data/input_races.csv", :headers => true) do |row|
	puts row
    Race.create(:date => row['date'])
end
end