task :import_csv => :environment do
require 'csv'   
CSV.foreach("/Users/max/Desktop/input.csv", :headers => true) do |row|
	puts row
        #Racer.create(:first_name => row['first_name'], :last_name => row['last_name'])
	Result.create(:rank => row['place'], :bib => row['bib'], :racer_id => row['racer'], :group => row['group'], :time => row['time'], :date => row['date'])
end
end