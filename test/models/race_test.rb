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
end
