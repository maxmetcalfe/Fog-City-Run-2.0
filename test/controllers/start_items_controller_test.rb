require 'test_helper'

class StartItemsControllerTest < ActionController::TestCase
  test "likely racers matches expected result" do
    likely_racers = @controller.get_likely_racers(races(:four).id)
    assert_equal [racers(:three), racers(:four), racers(:one)], likely_racers
  end

  test "likely racers shouldn't suggest a racer who is already registered" do
    start_item = StartItem.new(racer_id: racers(:three).id, start_time: Time.now, end_time: Time.now, bib: 101, race_id: races(:four).id)
    start_item.save
    likely_racers = @controller.get_likely_racers(races(:four).id)
    assert_equal [racers(:four), racers(:one)], likely_racers
  end

  test "destroying a start items destroys the record and returns to the race" do
    start_item = StartItem.new(racer_id: racers(:three).id, start_time: Time.now, end_time: Time.now, bib: 101, race_id: races(:four).id)
    start_item.destroy
    assert start_item.destroyed?
    assert_response 200
  end
end
