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
    start_item = start_items(:two)
    delete :destroy, id: start_item.id
    race = Race.find(start_item.race_id)
    assert_equal 1, race.start_items.count
    assert_redirected_to race
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

  test "should update start item" do
    start_item = start_items(:two)
    patch :update, id: start_item.id, start_item: { bib: 2 }
    updated_start_item = StartItem.find(start_item.id)
    # Confirm the bib value is updated.
    assert_equal 2, updated_start_item.bib
    assert_redirected_to races(:one)
  end

  test "invalid result update should redirect to result form" do
    start_item = start_items(:two)
    # racer_id: 0 - this racer does not exist.
    patch :update, id: start_item.id, start_item: { racer_id: 0 }
    updated_start_item = StartItem.find(start_item.id)
    assert_template :edit
    assert_select ".error-explanation", "Racer does not exist."
  end

  test "should create start item" do
    put :create, start_item: { bib: 101, racer_id: 4, group: "ALL", start_time: Time.now, end_time: Time.now, race_id: 1 }
    start_item = StartItem.order("created_at").last
    assert_equal 101, start_item.bib
    assert_equal 1, start_item.race_id
    assert_redirected_to races(:one)
  end

  test "invalid start item should redirect to start item form" do
    # racer_id: 0 - this racer does not exist.
    put :create, start_item: { bib: 101, racer_id: 0, group: "ALL", start_time: Time.now, end_time: Time.now, race_id: 1 }
    assert_template :new
  end
end
