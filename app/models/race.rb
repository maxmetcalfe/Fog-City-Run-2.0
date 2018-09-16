class Race < ActiveRecord::Base

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