class Racer < ActiveRecord::Base

  has_many :results

  require 'csv'

  def self.search(search)
    where("LOWER(first_name) LIKE LOWER(:search) OR LOWER(last_name) LIKE LOWER(:search)", search: "%#{search}%")
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Racer.create!(:first_name => row.to_hash["first_name"], :last_name => row.to_hash["last_name"], :id => Racer.maximum(:id).next)
	  end
  end

  validates :first_name, presence: true
  validates :last_name, presence: true
end
