class Order < ActiveRecord::Base

  after_initialize :init
  
  def init
    self.delivered = false if self.delivered.nil?
    self.quantity = 1
  end

  validates :item, presence: true
end
