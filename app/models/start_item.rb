class StartItem < ActiveRecord::Base
  validates :bib, presence: true
  validates :group, presence: true
  validates :racer_id, presence: true
  validates :race_id, presence: true
end
