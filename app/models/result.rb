class Result < ActiveRecord::Base
  belongs_to :racer
  belongs_to :race

  validates :rank, presence: true
  validates :bib, presence: true
  validates :racer_id, presence: true
  validates :group_name, presence: true
  validates :time, presence: true
  validates :race_id, presence: true
  validates :bib, numericality: { only_integer: true }
  validates :bib, numericality: { :greater_than_or_equal_to => 0 }
  validates :rank, numericality: { only_integer: true }
  validates :rank, numericality: { :greater_than_or_equal_to => 0 }
  validates :racer_id, numericality: { only_integer: true }
  validates :racer_id, numericality: { :greater_than_or_equal_to => 0 }
  validates :race_id, numericality: { only_integer: true }
  validates :race_id, numericality: { :greater_than_or_equal_to => 0 }
end