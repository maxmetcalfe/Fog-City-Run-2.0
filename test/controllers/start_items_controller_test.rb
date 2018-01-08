require 'test_helper'

class StartItemsControllerTest < ActionController::TestCase
  test "likely racers matches expected result" do
    likely_racers = @controller.get_likely_racers(races(:one).id)
    assert_equal likely_racers, [racers(:three), racers(:four)]
  end

  test "likely racers shouldn't suggest a racer who is already registered" do
    start_item = StartItem.new(racer_id: racers(:three).id, start_time: Time.now, end_time: Time.now, bib: 101, race_id: races(:four).id)
    start_item.save
    likely_racers = @controller.get_likely_racers(races(:four).id)
    assert_equal [racers(:four), racers(:one)], likely_racers
  end
end
