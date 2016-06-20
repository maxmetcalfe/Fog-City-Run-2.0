class Race < ActiveRecord::Base
	has_many :results
    def self.search(search)
        where("cast(date as varchar) LIKE :search", search: "%#{search}%")
    end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Race.create!(:date => row.to_hash["date"], :id => Race.maximum(:id).next)
	end
  end

  validates :date, presence: true

end