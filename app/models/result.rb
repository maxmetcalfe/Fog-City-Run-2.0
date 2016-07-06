class Result < ActiveRecord::Base
    belongs_to :racer
    belongs_to :race

  def self.import(file)

    for d in file["_json"]

      # Handle racer
      found_racer = Racer.where(last_name: d["last_name"], first_name: d["first_name"])
      if found_racer.blank?
        racer_id = Racer.maximum(:id).next
        Racer.create!(:first_name => d["first_name"], :last_name => d["last_name"], :id => racer_id)
      else
        racer_id = found_racer.first.id
      end

      # Handle race
      found_race = Race.where(date: d["date"])
      if found_race.blank?
        race_id = Race.maximum(:id).next
        Race.create!(:date => d["date"], :id => Race.maximum(:id).next)
      else
        race_id = found_race.first.id
      end
    end

  # Create a new result
  Result.create!(:rank => d["rank"], :bib => d["bib"],  :racer_id => racer_id, :group => d["group"], :time => d["time"],  :race_id => race_id, :id => Result.maximum(:id).next)

  end

  validates :rank, presence: true
  validates :bib, presence: true
  validates :racer_id, presence: true
  validates :group, presence: true
  validates :time, presence: true
  validates :race_id, presence: true
end
