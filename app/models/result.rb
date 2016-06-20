class Result < ActiveRecord::Base
    #attr_accessible :racer, :racer
    belongs_to :racer
    belongs_to :race

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Result.create!(:rank => row.to_hash["rank"], :bib => row.to_hash["bib"],  :racer_id => row.to_hash["racer_id"], :group => row.to_hash["group"], :time => row.to_hash["time"],  :race_id => row.to_hash["race_id"], :id => Result.maximum(:id).next)
	end
  end

  validates :rank, presence: true
  validates :bib, presence: true
  validates :racer_id, presence: true
  validates :group, presence: true
  validates :time, presence: true
  validates :race_id, presence: true
end
