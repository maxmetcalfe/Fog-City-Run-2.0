


task :import_csv => :environment do

require 'csv'   


CSV.foreach("/Users/max/Desktop/racers2.txt", :headers => true) do |row|
	puts row
    Racer.create(:first_name => row['first_name'], :last_name => row['last_name'])
end
end