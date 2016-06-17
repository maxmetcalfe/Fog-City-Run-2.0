class Result < ActiveRecord::Base
    #attr_accessible :racer, :racer
    belongs_to :racer
    belongs_to :race
end
