class Result < ActiveRecord::Base
    #attr_accessible :racer, :racer
    belongs_to :racer
    belongs_to :race

    require 'csv'

  def self.import(file)

    puts file.path

    CSV.foreach(file.path, headers: true) do |row|

      puts "Debuging"
      puts row[1]

      # Check if racer exists. If not, add new Racer
      found_racer = Racer.where(last_name: row[2], first_name: row[3])
      puts found_racer.class
      if found_racer.blank?
        racer_id = Racer.maximum(:id).next
        Racer.create!(:first_name => row[3], :last_name => row[2], :id => racer_id)
      else
        racer_id = found_racer.first.id
      end

      # Check if race exists. If not, add new Race
      found_race = Race.where(date: row[6])
      if found_race.blank?
        race_id = Race.maximum(:id).next
        Race.create!(:date => row[6])
      else
        race_id = found_race.first.id
      end

      # Create a new result
      Result.create!(:rank => row.to_hash["rank"], :bib => row.to_hash["bib"],  :racer_id => racer_id, :group => row.to_hash["group"], :time => row.to_hash["time"],  :race_id => race_id, :id => Result.maximum(:id).next)

  end
  end

  validates :rank, presence: true
  validates :bib, presence: true
  validates :racer_id, presence: true
  validates :group, presence: true
  validates :time, presence: true
  validates :race_id, presence: true
end
