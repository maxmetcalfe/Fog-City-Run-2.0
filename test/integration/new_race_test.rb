require "test_helper"

class NewRaceTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:marlin)
    get login_path
    post login_path, { session: { email: @admin_user.email,password: "password" } }
  end

  test "create new / upcoming race" do
    post races_path, { race: { date: Date.today + 1.year, state: "PLANNED" } }
    assert_redirected_to races_path
    follow_redirect!
    assert_select "a[href=?]", race_path(Race.maximum(:id))
    get race_path(Race.maximum(:id))
    assert_select "table", count: 2
    assert_select "td", count: 0
  end
end