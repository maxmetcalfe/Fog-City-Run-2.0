class Race < ActiveRecord::Base
  RACE_TYPES = ['Aquathon', '500m', '1000m', '2000m', '5k', 'Other'].freeze

  has_many :results
  has_many :start_items

  def self.search(search)
      where("cast(date as varchar) LIKE :search", search: "%#{search}%")
  end

  def send_results_email
    ResultMailer.results_email(self).deliver_now
  end

  validates :date, presence: true
end