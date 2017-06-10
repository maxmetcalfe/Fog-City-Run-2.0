class Racer < ActiveRecord::Base

  has_many :results

  def self.search(search)
    where("LOWER(first_name) LIKE LOWER(:search) OR LOWER(last_name) LIKE LOWER(:search)", search: "%#{search}%")
  end

  validates :first_name, presence: true
  validates :last_name, presence: true
end
