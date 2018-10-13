require 'test_helper'

class StartItemsControllerTest < ActionController::TestCase
  test "likely racers matches expected result" do
    likely_racers = @controller.get_likely_racers(races(:four).id)
    assert_equal [racers(:three), racers(:four), racers(:one)], likely_racers
  end

  test "likely racers shouldn't suggest a racer who is already registered" do
    start_item = StartItem.new(racer_id: racers(:three).id, group: "ALL", start_time: Time.now, end_time: Time.now, bib: 101, race_id: races(:four).id)
    start_item.save
    likely_racers = @controller.get_likely_racers(races(:four).id)
    assert_equal [racers(:four), racers(:one)].sort, likely_racers.sort
  end

  test "destroying a start items destroys the record and returns to the race" do
    start_item = StartItem.new(racer_id: racers(:three).id, group: "ALL", start_time: Time.now, end_time: Time.now, bib: 101, race_id: races(:four).id)
    start_item.destroy
    assert start_item.destroyed?
    assert_response 200
  end

  test "collect_time creates a result that matches the start item" do
    start_item = StartItem.new(racer_id: racers(:four).id, group: "ALL", start_time: Time.now, end_time: Time.now, bib: 101, race_id: races(:four).id)
    start_item.save!
    post :collect_time, :id => start_item.id, format: :json
    result = Result.where(racer_id: racers(:four).id, race_id: races(:four))
    assert_equal 1, result.count
  end

  test "collect_time modifies a racer's result if it exists already" do
    start_item = StartItem.new(racer_id: racers(:three).id, group: "ALL", start_time: Time.now, end_time: Time.now, bib: 101, race_id: races(:four).id)
    start_item.save!
    post :collect_time, :id => start_item.id, format: :json
    result = Result.where(racer_id: racers(:three).id, race_id: races(:four).id)
    assert_equal 1, result.count
    assert_equal "00:00:00.0", result[0].time
    assert_equal racers(:three), result[0].racer
    assert_equal races(:four), result[0].race
  end
end
