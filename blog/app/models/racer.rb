class Racer < ActiveRecord::Base
    #attr_accessible :racer_id
    has_many :results
end
