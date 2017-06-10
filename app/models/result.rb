class Result < ActiveRecord::Base
  belongs_to :racer
  belongs_to :race

  validates :rank, presence: true
  validates :bib, presence: true
  validates :racer_id, presence: true
  validates :group_name, presence: true
  validates :time, presence: true
  validates :race_id, presence: true
end