require 'test_helper'

class RacersControllerTest < ActionController::TestCase
  test "longest streak matches reality" do
    # Max should have a longest streak of 2.
    # Max has raced three races but only 2 in a "streak."
    longest_streak, streak = @controller.update_streak_calendar([1])
    assert_equal longest_streak.length, 2
  end

  test "current streak matches reality" do
    # Max should have a current streak of 0.
    # TO DO: Improve this test for the case that Max has a streak.
    longest_streak, streak = @controller.update_streak_calendar([1])
    assert_equal streak.length, 0
  end

  test "racers index display racers" do
    get 'index'
    assert_select "a[href=?]", racer_path(racers(:one))
    assert_select "a[href=?]", racer_path(racers(:two))
    assert_select "table", count: 1
    assert_select "tr", count: Racer.count + 1
  end

  test "racer show displays racer info" do
    get :show, id: racers(:one).id
    assert_select "h2", racers(:one).first_name + " " + racers(:one).last_name
    assert_select "table", 2
    for result in racers(:one).results
      assert_select "a[href=?]", race_path(result.race_id)
    end
  end
end
