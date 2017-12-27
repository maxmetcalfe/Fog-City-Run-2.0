require 'test_helper'

class RacerTest < ActiveSupport::TestCase
  test "should save valid racer" do
    racer = racers(:one)
    assert racer.save
  end

  test "should not save racer without name" do
    racer = racers(:one)
    racer.first_name = ""
    # racer.last_name = ""
    assert_not racer.save
  end

  test "should not have a negative race_count" do
    racer = racers(:one)
    racer.race_count = -1
    assert_not racer.save
  end

  test "should not save racer with a string race_count" do
    racer = racers(:one)
    racer.race_count = "bad"
    assert_not racer.save
  end

  test "should not save racer with a current streak longer than race count" do
    racer = racers(:one)
    racer.longest_streak = racer.race_count + 1
    assert_not racer.save
  end

  test "should not save racer with a longest streak longer than race count" do
    racer = racers(:one)
    racer.longest_streak = racer.race_count + 1
    assert_not racer.save
  end

  test "should not save racer with a current streak longer than longest streak" do
    racer = racers(:one)
    racer.current_streak = racer.longest_streak + 1
    assert_not racer.save
  end

  test "should not save racer with a space at the end of the first name" do
    racer = racers(:one)
    racer.first_name = racer.first_name + " "
    assert_not racer.save
  end

  test "should not save racer with a space at the end of the last name" do
    racer = racers(:one)
    racer.last_name = racer.last_name + " "
    assert_not racer.save
  end
end
