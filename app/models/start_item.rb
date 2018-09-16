class StartItem < ActiveRecord::Base
  belongs_to :racer
  belongs_to :race

  validates :bib, presence: true
  validates :group, presence: true
  validates :racer_id, presence: true
  validates :race_id, presence: true
end
