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

  test "racer show displays basic racer info" do
    get :show, id: racers(:one).id
    assert_select "h2", racers(:one).first_name + " " + racers(:one).last_name
    assert_select "table", 2
    for result in racers(:one).results
      assert_select "a[href=?]", race_path(result.race_id)
    end
  end

  test "racer show displays correct streak info" do
    racer = Racer.new(first_name: "Tommy", last_name: "Streak", race_count: 0, longest_streak: 0, current_streak: 0, fav_bib: 0)
    racer.save
    race1 = Race.new(date: Date.today)
    race1.save
    race2 = Race.new(date: Date.today -  1.week)
    race2.save
    race3 = Race.new(date: Date.today -  2.week)
    race3.save
    result1 = Result.new(rank: 1, bib: 1, racer_id: racer.id, race_id: race1.id, group_name: "ALL", time: "00:16:00")
    result1.save
    result2 = Result.new(rank: 1, bib: 1, racer_id: racer.id, race_id: race2.id, group_name: "ALL", time: "00:19:00")
    result2.save
    result3 = Result.new(rank: 1, bib: 1, racer_id: racer.id, race_id: race3.id, group_name: "ALL", time: "00:19:00")
    result3.save
    @controller.update_racer_info([racer.id])
    get :show, id: racer.id
    racer = Racer.find(racer.id)
    assert_select "h4:first-of-type", "Races: " + racer.race_count.to_s
    assert_select "h3:first-of-type", "Current: " + racer.current_streak.to_s
    assert_select "h3:last-of-type", "Longest: " + racer.longest_streak.to_s
  end
end
