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

  test "create race and add a start item" do
    post races_path, { race: { date: Date.today + 1.year, state: "PLANNED" } }
    race = Race.find(Race.maximum(:id))
    racer = Racer.find(@admin_user.racer_id)
    post start_items_path, { start_item: { race_id: race.id, bib: 1, group: "ALL", racer_id: 1 } }
    follow_redirect!
    assert_select "a[href=?]", start_item_path(StartItem.maximum(:id))
    assert_select "table", count: 2
    assert_select "td", count: 4
    put start_race_path(), { race_id: race.id }
    follow_redirect!
    assert_select "a[href=?]", stop_race_path(race.id)
    assert_select "a[href=?]", collect_time_path(StartItem.maximum(:id))
  end
end