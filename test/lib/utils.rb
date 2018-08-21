require "test_helper"

class UtilsTest < ActiveSupport::TestCase

  test "get_next_day_of_week() returns the correct Wednesday on a Monday" do
    travel_to Time.zone.local(2018, 8, 20, 11, 20, 20)
    assert_equal "2018-08-22".to_date, get_next_day_of_week(3)
  end

  test "get_next_day_of_week() returns the correct Wednesday on a Wednesday" do
    travel_to Time.zone.local(2015, 4, 8, 1, 20, 20)
    assert_equal "2015-04-08".to_date, get_next_day_of_week(3)
  end

  test "get_next_day_of_week() returns the correct Wednesday on a Thursday" do
    travel_to Time.zone.local(2015, 12, 17, 12, 00, 00)
    assert_equal "2015-12-23".to_date, get_next_day_of_week(3)
  end

  test "get_next_day_of_week() returns the correct Wednesday on a Sunday" do
    travel_to Time.zone.local(2017, 7, 16, 18, 00, 00)
    assert_equal "2017-07-19".to_date, get_next_day_of_week(3)
  end
  
  test "get_next_day_of_week() returns the correct Monday on a Sunday" do
    travel_to Time.zone.local(2018, 8, 19, 18, 00, 00)
    assert_equal "2018-08-20".to_date, get_next_day_of_week(1)
  end
  
  test "get_next_day_of_week() returns the correct Sunday on a Sunday" do
    travel_to Time.zone.local(2018, 8, 19, 18, 00, 00)
    assert_equal "2018-08-19".to_date, get_next_day_of_week(0)
  end
end
