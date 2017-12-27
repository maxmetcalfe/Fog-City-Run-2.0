class Racer < ActiveRecord::Base

  has_many :results
  after_initialize :init

  def init
    self.race_count = 0
    self.current_streak = 0
    self.longest_streak = 0
    self.fav_bib = 0
  end

  def self.search(search)
    where("LOWER(first_name) LIKE LOWER(:search) OR LOWER(last_name) LIKE LOWER(:search)", search: "%#{search}%")
  end

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :first_name, format: { with: /.*\S\z/, message: "cannot end with a space."}
  validates :last_name, format: { with: /.*\S\z/, message: "cannot end with a space."}
  validates :race_count, numericality: { only_integer: true }
  validates :race_count, numericality: { greater_than_or_equal_to: 0 }
  validates :longest_streak, numericality: { only_integer: true }
  validates :longest_streak, numericality: { :less_than_or_equal_to => :race_count }
  validates :current_streak, numericality: { only_integer: true }
  validates :current_streak, numericality: { :less_than_or_equal_to => :race_count }
  validates :current_streak, numericality: { :less_than_or_equal_to => :longest_streak }
  validates :fav_bib, numericality: { only_integer: true }
end
