require "test_helper"

class ResultTest < ActiveSupport::TestCase
  test "should save a valid result" do
    result = results(:one)
    assert result.save
  end

  test "should not save a result without a racer" do
    result = results(:one)
    result.racer_id = ""
    assert_not result.save
  end

  test "should not save a result without a race" do
    result = results(:one)
    result.race_id = ""
    assert_not result.save
  end

  test "should not save a result without a time" do
    result = results(:one)
    result.time = ""
    assert_not result.save
  end

  test "should not save a result without a rank" do
    result = results(:one)
    result.rank = ""
    assert_not result.save
  end

  test "should not save a result with an invalid rank" do
    result = results(:one)
    result.rank = -1
    assert_not result.save
  end

  test "should not save a result without a bib" do
    result = results(:one)
    result.bib = ""
    assert_not result.save
  end

  test "should not save a result with an invalid bib" do
    result = results(:one)
    result.bib = -1
    assert_not result.save
  end

  test "should not save a result without a group name" do
    result = results(:one)
    result.group_name = ""
    assert_not result.save
  end
end
