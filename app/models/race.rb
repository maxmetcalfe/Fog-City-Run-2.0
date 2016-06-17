class Race < ActiveRecord::Base
	has_many :results
    def self.search(search)
        where("cast(date as varchar) LIKE :search", search: "%#{search}%")
    end
end
