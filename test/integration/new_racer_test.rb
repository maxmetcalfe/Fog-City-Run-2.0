require "test_helper"

class NewRacerTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:marlin)
    get login_path
    post login_path, { session: { email: @admin_user.email,password: "password" } }
  end

  test "create new racer" do
    post racers_path, { racer: { first_name: "Third Eye", last_name: "Blind" } }
    assert_response 200
  end
end