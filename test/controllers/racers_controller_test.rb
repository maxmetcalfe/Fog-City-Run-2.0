require 'test_helper'

class RacersControllerTest < ActionController::TestCase

  test "update_streak_calendar() should return the expected results" do
    attributes = @controller.update_streak_calendar([racers(:one).id])
    assert_equal 2, attributes[:longest_streak]
    assert_equal 0, attributes[:current_streak]
    assert_same 2, attributes[:longest_streak_array].length
    assert_same 0, attributes[:current_streak_array].length
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

  test "destroying a racer properly removes the racer" do
    racer = Racer.new(first_name: "About", last_name: "To Go", race_count: 10, longest_streak: 0, current_streak: 0, fav_bib: 0)
    racer.save!
    delete :destroy, id: racer.id
    assert_redirected_to racers_path
    assert_not Racer.exists?(racer.id)
  end
end
