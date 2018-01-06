require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  test "from_seconds() returns the expected value" do
    assert_equal @controller.from_seconds(1500), "00:25:00.0"
  end

  test "from_seconds() returns the expected value - zero time" do
    assert_equal @controller.from_seconds(0), "00:00:00.0"
  end

  test "from_seconds() returns the expected value - 1 hour" do
    assert_equal @controller.from_seconds(3600), "01:00:00.0"
  end

  test "to_seconds() returns the expected value" do
    assert_equal @controller.to_seconds("00:25:00.0"), 1500
  end
  
  test "to_seconds() returns the expected value - zero time" do
    assert_equal @controller.to_seconds("00:00:00.0"), 0
  end
  
  test "to_seconds() returns the expected value - 1 hour" do
    assert_equal @controller.to_seconds("01:00:00.0"), 3600
  end
end
