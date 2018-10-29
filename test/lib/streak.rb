require "test_helper"

class UtilsTest < ActiveSupport::TestCase

  test "update_streak_calendar() returns the expected attributes for a racer persisting a streak" do
    # Travel to a Wednesday.
    travel_to Time.zone.local(2017, 6, 7, 19, 20, 00)
    attributes = update_streak_calendar(racers(:one))
    assert_equal 2, attributes[:longest_streak]
    assert_equal 2, attributes[:current_streak]
    assert_equal "[Wed, 31 May 2017, Wed, 07 Jun 2017]", attributes[:current_streak_array].to_s
    assert_equal "[Wed, 31 May 2017, Wed, 07 Jun 2017]", attributes[:longest_streak_array].to_s
  end

  test "update_streak_calendar() returns the expected attributes for a racer ending a streak" do
    # Travel to a Wednesday.
    travel_to Time.zone.local(2017, 6, 14, 19, 20, 00)
    attributes = update_streak_calendar(racers(:one))
    assert_equal 2, attributes[:longest_streak]
    assert_equal 0, attributes[:current_streak]
    assert_equal 0, attributes[:current_streak_array].length
    assert_equal "[Wed, 31 May 2017, Wed, 07 Jun 2017]", attributes[:longest_streak_array].to_s
  end

  test "update_streak_calendar() returns the expected attributes for a racer starting a new streak" do
    # Travel to a Wednesday.
    travel_to Time.zone.local(2017, 6, 21, 19, 20, 00)
    # Create a new race.
    race = Race.new(date: Date.today)
    race.save
    # The racer completes the race.
    result = Result.new(rank: 1, bib: 1, racer_id: racers(:one).id, race_id: race.id, group_name: "ALL", time: "00:25:00")
    result.save
    attributes = update_streak_calendar(racers(:one))
    assert_equal 2, attributes[:longest_streak]
    assert_equal 1, attributes[:current_streak]
    assert_equal "[Wed, 21 Jun 2017]", attributes[:current_streak_array].to_s
    assert_equal "[Wed, 31 May 2017, Wed, 07 Jun 2017]", attributes[:longest_streak_array].to_s
  end

  test "update_streak_calendar() returns the expected attributes for a race day entry" do
    # Travel to a Wednesday.
    travel_to Time.zone.local(2018, 8, 29, 19, 20, 00)
    # Create a new racer.
    racer = Racer.new(first_name: "Tommy", last_name: "Streak", race_count: 0, longest_streak: 0, current_streak: 0, fav_bib: 0)
    racer.save
    # Create a new race.
    race = Race.new(date: Date.today)
    race.save
    # The racer completes the race.
    result = Result.new(rank: 1, bib: 1, racer_id: racer.id, race_id: race.id, group_name: "ALL", time: "00:21:00")
    result.save
    # Update the streak for this racer.
    attributes = update_streak_calendar(racer)
    # Confirm we have included this race in the current streak
    assert_equal 1, attributes[:longest_streak]
    assert_equal 1, attributes[:current_streak]
    assert_equal "[Wed, 29 Aug 2018]", attributes[:current_streak_array].to_s
    assert_equal "[Wed, 29 Aug 2018]", attributes[:longest_streak_array].to_s
  end

  test "update_streak_calendar() returns the expected count data" do
    attributes = update_streak_calendar(racers(:one))
    assert_equal "Max M.", attributes[:count_data][:name]
    assert_equal "[[Wed, 31 May 2017, 1], [Wed, 07 Jun 2017, 2], [Wed, 11 Oct 2017, 3]]", attributes[:count_data][:data].to_s

    attributes = update_streak_calendar(racers(:two))
    assert_equal "Julia M.", attributes[:count_data][:name]
    assert_equal "[]", attributes[:count_data][:data].to_s

    attributes = update_streak_calendar(racers(:three))
    assert_equal "Gameof T.", attributes[:count_data][:name]
    assert_equal "[[Wed, 31 May 2017, 1], [Wed, 11 Oct 2017, 2]]", attributes[:count_data][:data].to_s
  end

end
