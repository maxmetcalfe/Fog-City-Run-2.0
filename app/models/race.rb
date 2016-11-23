class Race < ActiveRecord::Base

	has_many :results
	require 'csv'

  def self.search(search)
      where("cast(date as varchar) LIKE :search", search: "%#{search}%")
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Race.create!(:date => row.to_hash["date"], :id => Race.maximum(:id).next)
  end

  def send_results_email
    ResultMailer.results_email(self).deliver_now
  end
end
  validates :date, presence: true
end