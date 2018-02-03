require "test_helper"

class ResultsControllerTest < ActionController::TestCase

  test "result index displays basic result info" do
    get :index
    assert_select "p", count: 0
  end

  test "result show displays basic result info" do
    result = results(:one)
    get :show, id: result.id
    assert_select "p", count: 6
    assert_select "p:first-of-type", "Rank: " + result.rank.to_s
    assert_select "p:last-of-type", "Race: " + result.race_id.to_s
  end

  test "destroying a result changes associated counts and redirects to race" do
    result = results(:one)
    race = Race.find(result.race_id)
    delete :destroy, id: result.id
    assert_equal 3, race.results.count
    assert_redirected_to race
  end
end
