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

  test "races in the future appear as upcoming races" do
    race = Race.new(date: Date.today.next_day(1))
    race.save
    get :index
    # The headers for both tables are present.
    assert_select "h2", "Upcoming Races"
    assert_select "h2", "Past Races"
    # The upcoming race exists only once across both tables
    assert_select "a[href=?]", race_path(race), 1
    # The upcoming race exists in the upcoming race table.
    assert_select "table:first-of-type" do
      assert_select "tr" do
        assert_select "td:nth-child(1)", race.date.to_s
      end
    end
  end

  test "race search returns expected races from query string - single result" do
    get :index, :search => "2017-05-31"
    assert_select "a[href=?]", race_path(races(:one))
  end

  test "race search returns expected races from query string - multiple results" do
    get :index, :search => "2017"
    assert_select "a[href=?]", race_path(races(:one))
    assert_select "a[href=?]", race_path(races(:two))
    assert_select "a[href=?]", race_path(races(:four))
  end
end
