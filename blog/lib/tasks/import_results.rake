task :import_results => :environment do
require 'csv'   
CSV.foreach("/Users/max/Documents/Home/learningRubyonRails/input_data/results.csv", :headers => true) do |row|
	puts row
	Result.create(:rank => row['place'], :bib => row['bib'], :racer_id => row['racer_id'], :group => row['group'], :time => row['time'], :race_id => row['race_id'])
end
end