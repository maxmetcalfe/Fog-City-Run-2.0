class Racer < ActiveRecord::Base
    #attr_accessible :racer_id
    has_many :results
    def self.search(search)
        where("first_name LIKE :search OR last_name LIKE :search", search: "%#{search}%")
    end
end
