class Result < ActiveRecord::Base
    belongs_to :racer
    belongs_to :race

  require 'csv'

  def self.upload(file, date)
      out_string = ""
      new_results = []
      puts file
      puts date

      if file
        CSV.foreach(file.path, headers: true) do |row|

          # Handle racer
          found_racer = Racer.where(last_name: row["Last Name"], first_name: row["First Name"])
          if found_racer.blank?
            racer_id = Racer.maximum(:id).next
            Racer.create!(:first_name => row["First Name"], :last_name => row["Last Name"], :id => racer_id)
          else
            racer_id = found_racer.first.id
          end

          # Handle race
          found_race = Race.where(date: '01-01-2001')
          if found_race.blank?
            race_id = Race.maximum(:id).next
            Race.create!(:date => '01-01-2001', :id => Race.maximum(:id).next)
          else
            race_id = found_race.first.id
          end

          # Get next results id
          result_id = Result.maximum(:id).next

          Result.create!(:rank => row[0], :bib => row[1],  :racer_id => racer_id, :group_name => row[4], :time => row[5],  :race_id => race_id, :id => result_id)

          new_results.push(result_id)
        end
      end
      return new_results
  end

  validates :rank, presence: true
  validates :bib, presence: true
  validates :racer_id, presence: true
  validates :group_name, presence: true
  validates :time, presence: true
  validates :race_id, presence: true
end
