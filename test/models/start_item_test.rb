require 'test_helper'

class StartItemTest < ActiveSupport::TestCase
  test "should not save a start item without a bib" do
    start_item = start_items(:one)
    start_item.bib = ""
    assert_not start_item.save
  end

  test "a startItem without a group is not valid" do
    start_item = StartItem.new(bib: 100, racer_id: 1, race_id: 1)
    assert_not start_item.valid?
    assert_equal ["can't be blank"], start_item.errors.messages[:group]
  end

  test "a startItem without a race_id is not valid" do
    start_item = StartItem.new(bib: 100, racer_id: 1, group: "ALL")
    assert_not start_item.valid?
    assert_equal ["can't be blank"], start_item.errors.messages[:race_id]
  end

  test "a startItem referencing a non-existent race is not valid" do
    start_item = StartItem.new(bib: 100, racer_id: 1, race_id: 0, group: "ALL")
    assert_not start_item.valid?
    assert_equal ["does not exist."], start_item.errors.messages[:race]
  end

  test "a startItem without a racer_id is not valid" do
    start_item = StartItem.new(bib: 100, race_id: 1, group: "ALL")
    assert_not start_item.valid?
    assert_equal ["can't be blank"], start_item.errors.messages[:racer_id]
  end

  test "a startItem referencing a non-existent racer is not valid" do
    start_item = StartItem.new(bib: 100, racer_id: 0, race_id: 1, group: "ALL")
    assert_not start_item.valid?
    assert_equal ["does not exist."], start_item.errors.messages[:racer]
  end
end
