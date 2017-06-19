require 'test_helper'

class RacerTest < ActiveSupport::TestCase
  test "should not save racer without name" do
    racer = Racer.new
    assert_not racer.save
  end

  test "should not have a negative race_count" do
    racer = Racer.new
    racer.first_name = "John"
    racer.last_name = "Doe"
    racer.race_count = -1
    assert_not racer.save
  end

  test "should not save racer with a string race_count" do
    racer = Racer.new
    racer.first_name = "John"
    racer.last_name = "Doe"
    racer.race_count = "bad"
    assert_not racer.save
  end

  test "should not save racer with a current streak longer than race count" do
    racer = Racer.new
    racer.first_name = "John"
    racer.last_name = "Doe"
    racer.race_count = 1
    racer.longest_streak = 2
    assert_not racer.save
  end

  test "should not save racer with a longest streak longer than race count" do
    racer = Racer.new
    racer.first_name = "John"
    racer.last_name = "Doe"
    racer.race_count = 3
    racer.current_streak = 4
    racer.longest_streak = 3
    assert_not racer.save
  end

  test "should not save racer with a current streak longer than current_streak" do
    racer = Racer.new
    racer.first_name = "John"
    racer.last_name = "Doe"
    racer.race_count = 3
    racer.current_streak = 3
    racer.longest_streak = 2
    assert_not racer.save
  end
end
