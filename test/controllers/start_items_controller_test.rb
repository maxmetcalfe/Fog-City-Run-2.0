require 'test_helper'

class StartItemsControllerTest < ActionController::TestCase
  test "likely racers matches expected result" do
    likely_racers = @controller.get_likely_racers(races(:one).id)
    assert_equal likely_racers, [racers(:three), racers(:four)]
  end
end
