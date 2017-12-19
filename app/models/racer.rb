class Racer < ActiveRecord::Base

  # validate :validate_names

  has_many :results

  def self.search(search)
    where("LOWER(first_name) LIKE LOWER(:search) OR LOWER(last_name) LIKE LOWER(:search)", search: "%#{search}%")
  end

  # # Validates names
  # # Users sometimes add whitespace when adding new racers. This can break the app.
  # def validate_names
  #   if first_name[-1] == " " || last_name[-1] == " "
  #     errors.add(:base, "The first name or last name contains a space at the end.")
  #   end
  # end

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
