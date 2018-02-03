require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "should save a valid order" do
    order = orders(:hat)
    assert order.save
  end

  test "should not save an order without an item" do
    order = orders(:hat)
    order.item = ""
    assert_not order.save
  end

  test "should not save an order with an invalid quantity" do
    order = orders(:hat)
    order.quantity = -1
    assert_not order.save
  end

  test "should not save an order without a quantity" do
    order = orders(:hat)
    order.quantity = ""
    assert_not order.save
  end

  test "should not save an order without a size" do
    order = orders(:hat)
    order.size = ""
    assert_not order.save
  end

  test "should not save an order without a delivered attribute" do
    order = orders(:hat)
    order.delivered = ""
    assert_not order.save
  end
end
