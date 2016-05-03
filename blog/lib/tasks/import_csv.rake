# lib/tasks/migrate_topics.rake

desc 'Migrate topics from legacy database to new database'
task import_csv: :environment do
require 'csv'   
require 'articles' 

CSV.foreach("/Users/max/Desktop/in.csv", :headers => true) do |row|
	puts row
    Articles.create(:title => row['name'], :text => row['text'])
end
end