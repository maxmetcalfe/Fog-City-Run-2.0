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

  test "should update result" do
    result = results(:six)
    patch :update, id: result.id, result: { bib: 30, time: "00:11:00.0" }
    updated_result = Result.find(result.id)
    # Confirm the bib value is updated.
    assert_equal 30, updated_result.bib
    # Confirm the time has been updated.
    assert_equal "00:11:00.0", updated_result.time
    # Confirm the rank has been updated (via validate_ranks()).
    assert_equal 1, updated_result.rank
    assert_redirected_to races(:one)
  end

  test "invalid result update should redirect to result form" do
    result = results(:six)
    patch :update, id: result.id, result: { racer_id: 0 }
    updated_result = Result.find(result.id)
    assert_template :edit
    assert_select ".error-explanation", "Racer does not exist."
  end
end
