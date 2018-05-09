require "test_helper"

class RegistrationTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:marlin)
    @non_admin_user = users(:fuzz)
  end

  test "register a race as a non-admin user" do
    get login_path
    post login_path, { session: { email: @non_admin_user.email, password: "password" } }
    post start_items_path, { start_item: { racer_id: @non_admin_user.racer_id, group: "ALL", start_time: Time.now, end_time: Time.now, bib: 20, race_id: races(:four).id } }
    get race_path(races(:four).id)
    assert_response 200
    racer = Racer.find(@non_admin_user.racer_id)
    assert_select "#start-items-table tr:nth-child(1) td:nth-child(3)", racer.first_name + " " + racer.last_name
  end

  test "register a race as an admin user" do
    get login_path
    post login_path, { session: { email: @admin_user.email, password: "password" } }
    post start_items_path, { start_item: { racer_id: @admin_user.racer_id, group: "ALL", start_time: Time.now, end_time: Time.now, bib: 20, race_id: races(:four).id } }
    get race_path(races(:four).id)
    assert_response 200
    racer = Racer.find(@admin_user.racer_id)
    assert_select "#start-items-table tr:nth-child(1) td:nth-child(3)", racer.first_name + " " + racer.last_name
  end
end