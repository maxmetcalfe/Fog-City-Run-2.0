require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  test "from_seconds() returns the expected value" do
    assert_equal "00:25:00.0", @controller.from_seconds(1500.0)
  end

  test "from_seconds() returns the expected value - zero time" do
    assert_equal "00:00:00.0", @controller.from_seconds(0.0)
  end

  test "from_seconds() returns the expected value - 1 hour" do
    assert_equal "01:00:00.0", @controller.from_seconds(3600.0)
  end

  test "from_seconds() returns the expected value - 1 hour, > 10 seconds" do
    assert_equal "01:00:30.0", @controller.from_seconds(3630.0)
  end

  test "to_seconds() returns the expected value" do
    assert_equal 1500.0, @controller.to_seconds("00:25:00.0")
  end
  
  test "to_seconds() returns the expected value - zero time" do
    assert_equal 0, @controller.to_seconds("00:00:00.0")
  end
  
  test "to_seconds() returns the expected value - 1 hour" do
    assert_equal 3600.0, @controller.to_seconds("01:00:00.0")
  end

  test "validate ranks maintains the correct rank order" do
    @controller.validate_ranks(races(:one))
    rank = 1
    for result in races(:one).results
      assert_equal result.rank, rank
      rank += 1
    end
  end
end
