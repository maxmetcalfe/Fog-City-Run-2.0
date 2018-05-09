require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin_user = users(:marlin)
    @non_admin_user = users(:sophie)
  end

  test "login admin / racer associated user with valid information" do
    get login_path
    post login_path, { session: { email: @admin_user.email, password: "password" } }
    assert_redirected_to racers_path
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", racer_path(Racer.find(@admin_user.racer_id))
    assert_select ".navbar-right", @admin_user.first_name + " " + @admin_user.last_name + " (Admin) |\nShow |\nEdit | Log out"
  end

  test "login non-admin / unassociated user with valid information" do
    get login_path
    post login_path, { session: { email: @non_admin_user.email, password: "password" } }
    assert_redirected_to racers_path
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select ".navbar-right", @non_admin_user.first_name + " " + @non_admin_user.last_name + " |\nEdit | Log out"
  end

  test "logout admin user" do
    get login_path
    post login_path, { session: { email: @admin_user.email, password: "password" } }
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
  end

  test "logout non-admin user" do
    get login_path
    post login_path, { session: { email: @non_admin_user.email, password: "password" } }
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
  end
end