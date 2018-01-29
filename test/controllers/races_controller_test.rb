require 'test_helper'

class RacesControllerTest < ActionController::TestCase

  test "destroying a races removes related results" do
    race = Race.new(date: Date.today)
    race.save
    result1 = Result.new(rank: 1, bib: 1, racer_id: racers(:one).id, race_id: race.id, group_name: "ALL", time: "00:21:00")
    result1.save
    result2 = Result.new(rank: 2, bib: 2, racer_id: racers(:two).id, race_id: race.id, group_name: "ALL", time: "00:22:00")
    result2.save
    assert_equal 2, race.results.count
    get :destroy, id: race.id
    assert_equal 0, race.results.count
  end
end
