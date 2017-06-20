require 'test_helper'

class RacersControllerTest < ActionController::TestCase
  test "longest streak matches reality" do
    # Max should have a longest streak of 2.
    attributes = @controller.update_streak_calendar([1])
    assert_equal attributes[:longest_streak], 2
  end

  test "current streak matches reality" do
    # Max should have a current streak of 0.
    attributes = @controller.update_streak_calendar([1])
    assert_equal attributes[:current_streak], 0
  end
end
