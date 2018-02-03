class Order < ActiveRecord::Base

  after_initialize :init

  def init
    self.delivered ||= false
    self.quantity ||= 1
  end

  validates :item, presence: true
  validates :size, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { only_integer: true }
end
