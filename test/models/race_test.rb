require 'test_helper'

class RaceTest < ActiveSupport::TestCase
  test "should not save race without date" do
    race = Race.new
    assert_not race.save
  end

  test "should save race with valid date" do
    race = Race.new
    race.date = "2017-12-27"
    assert race.save
  end

  test "should not save race with invalid date" do
    race = Race.new
    race.date = "invalid"
    assert_not race.save
  end

  test "should save race with valid date with correct data type" do
    race = Race.new
    race.date = "2017-12-27"
    assert_equal race.date.class, Date
  end
end
