task :import_results => :environment do
require 'csv'   
CSV.foreach("/Users/max/Documents/Home/Fog-City-Run-2.0/input_data/results.csv", :headers => true) do |row|
    result = Result.create(:rank => row['place'], :bib => row['bib'], :racer_id => row['racer_id'], :group => row['group'], :time => row['time'], :race_id => row['race_id'])
    if result.valid?
      puts "It worked!"
    else
      puts "It didn't work"
      puts row['racer_id']
    end
  end
end