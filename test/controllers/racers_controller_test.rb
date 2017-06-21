require 'test_helper'

class RacersControllerTest < ActionController::TestCase
  test "longest streak matches reality" do
    # Max should have a longest streak of 2.
    longest_streak, streak = @controller.update_streak_calendar([1])
    assert_equal longest_streak.length, 2
  end

  test "current streak matches reality" do
    # Max should have a current streak of 0.
    longest_streak, streak = @controller.update_streak_calendar([1])
    assert_equal streak.length, 0
  end
end
