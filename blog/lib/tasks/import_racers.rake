task :import_racers => :environment do
require 'csv'   
CSV.foreach("/Users/max/Documents/Home/learningRubyonRails/input_data/input_racers_for_import.csv", :headers => true) do |row|
	puts row
    Racer.create(:first_name => row['first_name'], :last_name => row['last_name'])
end
end