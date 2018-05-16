require 'test_helper'

class StartItemTest < ActiveSupport::TestCase
  test "should not save a start item without a bib" do
    start_item = start_items(:one)
    start_item.bib = ""
    assert_not start_item.save
  end

  test "should not save a start item without a racer id" do
    start_item = start_items(:one)
    start_item.racer_id = ""
    assert_not start_item.save
  end

  test "should not save a start item without a race id" do
    start_item = start_items(:one)
    start_item.race_id = ""
    assert_not start_item.save
  end

  test "should not save a start item without a group" do
    start_item = start_items(:one)
    start_item.group = ""
    assert_not start_item.save
  end
end
