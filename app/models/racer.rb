class Racer < ActiveRecord::Base

  has_many :results

  def self.search(search)
    where("LOWER(first_name) LIKE LOWER(:search) OR LOWER(last_name) LIKE LOWER(:search)", search: "%#{search}%")
  end

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :race_count, numericality: { only_integer: true }
  validates :race_count, numericality: { greater_than_or_equal_to: 0 }
  validates :longest_streak, numericality: { only_integer: true }
  validates :longest_streak, numericality: { :less_than_or_equal_to => :race_count }
  validates :current_streak, numericality: { only_integer: true }
  validates :current_streak, numericality: { :less_than_or_equal_to => :race_count }
  validates :current_streak, numericality: { :less_than_or_equal_to => :longest_streak }
  validates :fav_bib, numericality: { only_integer: true }
end
