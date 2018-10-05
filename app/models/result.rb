require "#{Rails.root}/lib/utils"

class Result < ActiveRecord::Base
  belongs_to :racer
  belongs_to :race
  after_destroy :update_racer_info

  validates :rank, presence: true
  validates :bib, presence: true
  validates :racer_id, presence: true
  validates_presence_of :racer, message: "does not exist."
  validates :group_name, presence: true
  validates :time, presence: true
  validates :race_id, presence: true
  validates_presence_of :race, message: "does not exist."
  validates :bib, numericality: { only_integer: true }
  validates :bib, numericality: { :greater_than_or_equal_to => 0 }
  validates :rank, numericality: { only_integer: true }
  validates :rank, numericality: { :greater_than_or_equal_to => 0 }
end
